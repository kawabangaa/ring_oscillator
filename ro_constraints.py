

FILE_PATH = ""
NUM_OF_INVERTERS = 121
NUM_OF_RO = 5
RO_REF_COORDS = [(0, 0), (46, 100), (46, 50), (104, 50), (104, 150)] # should have NUM_OF_RO tuples of 2 numbers.

# constants for constraints
slice_constraints = """# SLICE BEGIN {lut_id}
set_property DONT_TOUCH true [get_cells {lut_hir}/A_LUT6_D_INST]
set_property BEL  A6LUT [get_cells {lut_hir}/A_LUT6_D_INST]
set_property LOC SLICE_{slice_cords} [get_cells {lut_hir}/A_LUT6_D_INST]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets ro_generation[lut_id].ro_inst/ro_internal_1]
# SLICE END {lut_id}\n"""
# generates a list of (x,y) tuples that acts as coordination reference to (0,0) using NUM_OF_INVERTERS LUTs.


def gen_canvas(shape):
    # import tkinter
    # root = tkinter.Tk()
    # canvas = tkinter.Canvas(root)
    # canvas.pack()
    # prev = None
    # for coord in shape:
    #     if coord == None:
    #         break
    #     if prev != None:
    #         canvas.create_line(prev[0], prev[1],coord[0], coord[1])
    #     prev = coord
    # root.mainloop()
    import pygame
    from math import pi
    BLACK = (0, 0, 0)
    pygame.init()
    # Set the height and width of the screen
    size = [400, 300]
    screen = pygame.display.set_mode(size)

    while True:
        screen.fill((255, 255, 255))
        prev = None
        for coord in shape:
            if coord == None:
                break
            if prev != None:
                pygame.draw.line(screen, BLACK, [prev[0], prev[1]], [coord[0], coord[1]], 1)
            prev = coord
        pygame.display.flip()



def generate_shape(shape):
    idx = 0
    x = 0
    y = 1
    cursor = [0,0]
    for i in range (10):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1
    for i in range(10):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] += 1

    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[y] -= 1
    for i in range(9):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] -= 1
    for i in range(8):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] -= 1
    for i in range(8):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] += 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[y] += 1

    for i in range(7):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] -= 1
    for i in range(6):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1
    for i in range(8):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] += 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] -= 1
    for i in range(7):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] -= 1
    for i in range(4):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] -= 1
    for i in range(6):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] += 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[y] += 1
    for i in range(5):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] -= 1

    #?
    for i in range(2):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1


    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] += 1
    for i in range(1):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] -= 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] += 1
    for i in range(1):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] += 1
    for i in range(1):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] -= 1
    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] += 1
    for i in range(1):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1

    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[x] += 1
    cursor[y] += 1

    for i in range(7):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] -= 1

    for i in range(10):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] -= 1
    print(shape)
    gen_canvas(shape)
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] += 1
    # gen_canvas(shape)
    # for i in range(7):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[y] -= 1
    # for i in range(9):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    #
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[x] -= 1
    # cursor[y] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1


    # for i in range (24):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[y] += 1
    # for i in range(6):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] -= 1
    # for i in range(3):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] -= 1
    # for i in range(9):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[y] -= 1
    # for i in range(9):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] += 1
    # for i in range(9):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[y] += 1
    # for i in range(3):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] -= 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1
    # shape[idx] = (cursor[x], cursor[y])
    # idx += 1
    # cursor[y] += 1
    # for i in range(6):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] += 1
    # for i in range(24):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[y] -= 1
    # for i in range(15):
    #     shape[idx] = (cursor[x], cursor[y])
    #     idx += 1
    #     cursor[x] -= 1

# actual script
shape_coords = [None]*NUM_OF_INVERTERS
generate_shape(shape_coords)
print (shape_coords)
#f=open(FILE_PATH)

#f.close()