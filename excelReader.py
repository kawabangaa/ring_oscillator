

def readExcel(path):
    """
    draws a line between all the points
    reads the first sheet of excel file.
    the document is expected to be a table with numbers 0 - K where K< table size.
    the output is a list of (row,col), the index of the item is the number appeared in the file.
    :param path:
    :return:
    """
    from xlrd import open_workbook
    wb = open_workbook(path)
    for sheet in wb.sheets():
        number_of_rows = sheet.nrows
        number_of_columns = sheet.ncols

        items = [None]*(number_of_rows*number_of_columns)

        for row in range(number_of_rows):
            values = []
            for col in range(number_of_columns):
                value  = (sheet.cell(row,col).value)
                try:
                    value = int(value)
                except ValueError:
                    pass
                finally:
                    if value != '':
                        items[value] = [row, col]


        return [x for x in items if x is not None]

