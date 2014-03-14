# -*- coding: utf-8 -*-
u"""
    hgpunchcard
    ~~~~~~~~~~~

    Mercurial extension to create a "punch card" graph à la github for a
    hg repository.  Borrows the PyQt drawing code from the same-name bzr
    extension, from <http://bzr.oxygene.sk/bzr-plugins/punchcard>.

    Uses PyQt4 for drawing the punch card.

    Usage: activate the extension in hgrc::

        [extensions]
        hgpunchcard = path/to/hgpunchcard.py

    Then, use "hg punchcard" to generate a graph.

    :copyright: 2010-2011 by
                Lukáš Lalinsky <lalinsky@gmail.com>,
                Georg Brandl <georg@python.org>.
    :license:
        This program is free software; you can redistribute it and/or modify it
        under the terms of the GNU General Public License as published by the
        Free Software Foundation; either version 2 of the License, or (at your
        option) any later version.

        This program is distributed in the hope that it will be useful, but
        WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
        General Public License for more details.

        You should have received a copy of the GNU General Public License along
        with this program; if not, write to the Free Software Foundation, Inc.,
        51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
"""
from datetime import datetime

from mercurial import util


days = 'Mon Tue Wed Thu Fri Sat Sun'.split()

def punchcard(ui, repo, *pats, **opts):
    """Generate a "punch card" graph of commit times.

    For drawing the graph, either PyQt4 or matplotlib can be used.  The default
    is PyQt4, unless the --mpl option is given.

    Normally, all commits are registered in local time, so that commits at 10 AM
    local time in Europe and the USA show up on the same punch card entry.  If
    --utc is given, all commit times are converted to UTC before registered.
    """
    if pats:
        raise util.Abort('no argument allowed')

    filename = opts['filename']
    if opts['datemin']:
        datemin = datetime.strptime(opts['datemin'], '%Y-%m-%d')
    else:
        datemin = None
    if opts['datemax']:
        datemax = datetime.strptime(opts['datemax'], '%Y-%m-%d')
    else:
        datemax = None
    users_include = set(opts['user'])
    users_exclude = set(opts['notuser'])
    user_filter = bool(users_include or users_exclude)
    title = opts.get('title')
    font = opts.get('font') or 'Arial'
    utc = opts.get('utc')

    data = [[0] * 24 for i in range(7)]
    cl = repo.changelog
    n = 0
    ui.status('filtering changesets\n')
    for i in xrange(len(cl)):
        node = cl.read(cl.node(i))
        # node[2] is a tuple of the date in UTC and the timezone offset.
        # If --utc is given, the offset can be ignored; otherwise
        if utc:
            date = datetime.utcfromtimestamp(node[2][0])
        else:
            date = datetime.utcfromtimestamp(node[2][0] - node[2][1])
        if (datemin and date < datemin) or (datemax and date > datemax):
            continue
        if user_filter:
            user = node[1]
            if users_include and user not in users_include:
                continue
            if user in users_exclude:
                continue
        day = (int(date.strftime('%w')) - 1) % 7
        data[day][date.hour] += 1
        n += 1
    if n == 0:
        raise util.Abort('no matching changesets found')
    else:
        ui.status('punched %d changesets\n' % n)
    maxvalue = max(max(i) for i in data) or 1
    xs, ys, rs, ss = [], [], [], []
    for y, d in enumerate(data):
        for x, n in enumerate(d):
            xs.append(x); ys.append(y); rs.append(13.*n/maxvalue)
            ss.append(4.*n**2/maxvalue)

    try:
        if opts.get('mpl') or opts.get('svg'):
            raise ImportError
        from PyQt4.QtCore import Qt, QPointF, QRectF
        from PyQt4.QtGui import QApplication, QColor, QFont, QImage, QLabel, \
             QMainWindow, QPainter, QPixmap
    except ImportError:
        try:
            if opts.get('svg'):
                raise ImportError
            from matplotlib import pyplot
        except ImportError:
            if not opts.get('svg'):
                ui.status('Writing as SVG since neither PyQt4 nor '
                          'matplotlib is available\n')
            if filename.endswith('.png'):
                filename = filename[:-4] + '.svg'

            f = open(filename, 'w')
            f.write('<?xml version="1.0" standalone="no"?>\n')
            f.write('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" '
                    '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n')

            o = title and 30 or 0  # y coordinate offset
            f.write('<svg width="800" height="{0}" version="1.1" '
                    'xmlns="http://www.w3.org/2000/svg">\n'.format(300+o))
            f.write('<style type="text/css"> circle {{fill: black;}} '
                    'text {{font-family:{0};font-size:12;}} '
                    '.label{{font-size:12px;}}</style>\n'.format(font))
            f.write('<rect x="0" y="0" width="800" height="{0}" '
                    'style="fill:#efefef;"/>\n'.format(300+o))
            f.write('<line x1="35.5" y1="{0}" x2="{1}" y2="{0}" '
                    'style="stroke:black;stroke-width:2"/>\n'
                    .format(264.5+o,45.5+24*31))
            f.write('<line x1="35.5" y1="{0}" x2="35.5" y2="{1}" '
                    'style="stroke:black;stroke-width:2"/>\n'
                    .format(14.5+o,264.5+o))
            for i, text in enumerate(days):
                f.write('<text class="label" x="7.5" y="{0}">{1}</text>\n'
                        .format(34.5+i*34+o,text))
            for i in range(24):
                f.write('<text class="label" x="{0}" y="{1}">{2:02}</text>\n'
                        .format(53.5 + i*31, 280.5 + o, i))
            for x, y, r in zip(xs, ys, rs):
                f.write('<circle cx="{0}" cy="{1}" r="{2}" fill="black"/>\n'
                        .format(58.5 + x*31, 30.5 + y*34 + o, r))
            if title:
                f.write('<text x="400" y="20" style="text-anchor:middle;">'
                        '{0}</text>\n'.format(title))

            f.write('</svg>')
            f.close()
            ui.status('created punch card in %s\n' % filename)

        else:
            pyplot.rc('font', family=font)
            # create a figure an axes with the same background color
            fig = pyplot.figure(figsize=(8, title and 3 or 2.5),
                                facecolor='#efefef')
            ax = fig.add_subplot('111', axisbg='#efefef')
            # make the figure margins smaller
            if title:
                fig.subplots_adjust(left=0.06, bottom=0.04, right=0.98, top=0.95)
                ax.set_title(title, y=0.96).set_color('#333333')
            else:
                fig.subplots_adjust(left=0.06, bottom=0.08, right=0.98, top=0.99)
            # don't display the axes frame
            ax.set_frame_on(False)
            # plot the punch card data
            ax.scatter(xs, ys[::-1], s=ss, c='#333333', edgecolor='#333333')
            # hide the tick lines
            for line in ax.get_xticklines() + ax.get_yticklines():
                line.set_alpha(0.0)
            # draw x and y lines (instead of axes frame)
            dist = -0.8
            ax.plot([dist, 23.5], [dist, dist], c='#555555')
            ax.plot([dist, dist], [dist, 6.4], c='#555555')
            # select new axis limits
            ax.set_xlim(-1, 24)
            ax.set_ylim(-0.9, 6.9)
            # set tick labels and draw them smaller than normal
            ax.set_yticks(range(7))
            for tx in ax.set_yticklabels(days[::-1]):
                tx.set_color('#555555')
                tx.set_size('x-small')
            ax.set_xticks(range(24))
            for tx in ax.set_xticklabels(['%02d' % x for x in range(24)]):
                tx.set_color('#555555')
                tx.set_size('x-small')
            # get equal spacing for days and hours
            ax.set_aspect('equal')
            fig.savefig(filename)
            ui.status('created punch card in %s\n' % filename)
            if opts.get('display'):
                pyplot.show()

    else:
        app = QApplication([])
        o = title and 30 or 0  # y coordinate offset
        image = QImage(800, 300 + o, QImage.Format_RGB32)
        painter = QPainter(image)
        painter.setRenderHints(QPainter.Antialiasing)
        painter.fillRect(0, 0, 800, 300 + o, QColor('#efefef'))
        painter.setPen(QColor('#555555'))
        painter.drawLine(QPointF(35.5, 264.5 + o),
                         QPointF(45.5 + 24 * 31, 264.5 + o))
        painter.drawLine(QPointF(35.5, 14.5 + o), QPointF(35.5, 264.5 + o))
        painter.setFont(QFont(font, 8))
        for i, text in enumerate(days):
            painter.drawText(QPointF(7.5, 34.5 + i * 34 + o), text)
        for i in range(24):
            text = '%02d' % i
            painter.drawText(QPointF(53.5 + i * 31, 280.5 + o), text)
        painter.setBrush(QColor('#333333'))
        painter.setPen(QColor('#333333'))
        for x, y, r in zip(xs, ys, rs):
            painter.drawEllipse(QPointF(58.5 + x * 31, 30.5 + y * 34 + o), r, r)
        if title:
            painter.setFont(QFont(font, 12))
            painter.drawText(QRectF(0, 15, 800, 20), Qt.AlignCenter, title)
        painter.end()
        image.save(filename)
        ui.status('created punch card in %s\n' % filename)
        if opts.get('display'):
            win = QMainWindow()
            win.setWindowTitle('punchcard display')
            win.resize(800, 300 + o)
            lbl = QLabel(win)
            lbl.resize(800, 300 + o)
            lbl.setPixmap(QPixmap.fromImage(image))
            win.show()
            app.exec_()

cmdtable = {
    'punchcard':
        (punchcard,
         [('o', 'filename', 'punchcard.png', 'name of the file created'),
          ('', 'display', False, 'display graph immediately'),
          ('', 'mpl', False, 'use matplotlib even if PyQt is available'),
          ('', 'svg', False, 'always write SVG file'),
          ('t', 'title', '', 'title for punch card'),
          ('', 'font', '', 'font to use (default Arial)'),
          ('', 'datemin', '', 'start date (yyyy-mm-dd)'),
          ('', 'datemax', '', 'end date (yyyy-mm-dd)'),
          ('u', 'user', [], 'author to include, default all'),
          ('U', 'notuser', [], 'author to exclude, default none'),
          ('', 'utc', False, 'use UTC for every commit, not local time'),
          ],
         'hg punchcard OPTION... [-o filename] [-u user1 -U user2 ...]')
}
