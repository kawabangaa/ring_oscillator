import datetime

FILE_PATH = "/home/kaki/Documents/Ring Oscillator/hdl/constraints_test.xdc"
NUM_OF_INVERTERS = 121
NUM_OF_RO = 5
RO_REF_COORDS = [(0, 0), (46, 100), (46, 50), (104, 50), (104, 150)] # should have NUM_OF_RO tuples of 2 numbers.
CONVERTION_TBL = [None]*(NUM_OF_INVERTERS*2)


# constants for constraints
slice_constraints = """\n# LUT number {inv_num} in RO number {ro_num} BEGIN
set_property DONT_TOUCH true [get_cells {path}.INVERTER]
set_property BEL  A6LUT [get_cells {path}.INVERTER]
set_property LOC SLICE_{coords} [get_cells {path}.INVERTER]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets {path_to_ro}/ro_internal_1]
# END LUT number {inv_num} in RO number {ro_num}\n"""
path_to_ro = "ro_generation[{ro_num}].ro_inst"
path_to_first_ro = path_to_ro + "/ro_gen[0].first_ro"
path_to_middle_ro = path_to_ro+"/ro_gen[{inv_num}].middle_ro"
path_to_last_ro = path_to_ro+"/ro_gen[{inv_num}].last_ro"

# generates a list of (x,y) tuples that acts as coordination reference to (0,0) using NUM_OF_INVERTERS LUTs.

def create_convertion_table():
    curr_row = 0
    for row_idx in range(0,NUM_OF_INVERTERS):
        row_even = [None]*(NUM_OF_INVERTERS)
        row_odd = [None] * (NUM_OF_INVERTERS)
        curr_cul = 0
        for col_idx in range(NUM_OF_INVERTERS):
            if (col_idx%2) == 0:
                row_even[curr_cul] = [col_idx,row_idx]
            else:
                row_odd[curr_cul] = [col_idx, row_idx]
                curr_cul +=1
        CONVERTION_TBL[curr_row] = list(row_even)
        curr_row+=1
        CONVERTION_TBL[curr_row] = list(row_odd)
        curr_row += 1


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
def draw(shape):
    grid = [["_" for i in range(NUM_OF_INVERTERS)] for j in range(NUM_OF_INVERTERS)]
    idx = 0
    for coords in shape:
        grid[coords[1]][coords[0]] = "{0:02d}".format(idx)
        idx += 1
    #printing the grid
    for row_idx in range(NUM_OF_INVERTERS):
        print(','.join(grid[row_idx]))



def generate_shape(shape):
    idx = 0
    x = 0
    y = 1
    cursor = [2,1]
    # 0-9
    for i in range (10):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[y] += 1
    # 10-20
    for i in range(10):
        shape[idx] = (cursor[x], cursor[y])
        idx += 1
        cursor[x] += 1

    shape[idx] = (cursor[x], cursor[y])
    idx += 1
    cursor[y] -= 1
    # 21 - 30
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
    shape[idx] = (cursor[x], cursor[y])
    #print(shape)
    #gen_canvas(shape)
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
def convert_tuple_to_coords(tup):
    return "X{x}Y{y}".format(x = tup[0], y = tup[1])
def ro_contraint(shape):
    output = datetime.datetime.now().strftime("## %I:%M%p on %B %d, %Y\n")
    for ro in range(NUM_OF_RO):


        for inverter in range(0,NUM_OF_INVERTERS):

            xilinx_inv_coords_unreferenced = [-1,-1]
            regular_to_xilnx_coords_convertion(shape[inverter],xilinx_inv_coords_unreferenced)
            inv_coords = [xilinx_inv_coords_unreferenced[0] + RO_REF_COORDS[ro][0], xilinx_inv_coords_unreferenced[1] + RO_REF_COORDS[ro][1]]
            if inverter == 0:
                output += slice_constraints.format(coords = convert_tuple_to_coords(inv_coords), inv_num = inverter, ro_num = ro, path_to_ro = path_to_ro.format(ro_num = ro), path = path_to_first_ro.format(ro_num = ro))
            elif inverter == (NUM_OF_INVERTERS - 1):
                output += slice_constraints.format(coords = convert_tuple_to_coords(inv_coords),inv_num=inverter, ro_num=ro, path_to_ro=path_to_ro.format(ro_num = ro),
                                                       path=path_to_last_ro.format(ro_num=ro, inv_num = inverter))
            else :
                output += slice_constraints.format(coords = convert_tuple_to_coords(inv_coords),inv_num=inverter, ro_num=ro, path_to_ro=path_to_ro.format(ro_num = ro),
                                                       path=path_to_middle_ro.format(ro_num=ro, inv_num = inverter))
    return output
def regular_to_xilnx_coords_convertion(coords_in,coords_out):
    coords_out[0] = CONVERTION_TBL[coords_in[1]][coords_in[0]][0]
    coords_out[1] = CONVERTION_TBL[coords_in[1]][coords_in[0]][1]
    #print("coord in: {i} matches to {o}\n".format(i = coords_in, o = coords_out))







# actual script
shape = [None]*NUM_OF_INVERTERS
create_convertion_table()
#print(CONVERTION_TBL)

generate_shape(shape)
draw(shape)
output =ro_contraint(shape)


f=open(FILE_PATH,"w")
f.write(output)
f.close()