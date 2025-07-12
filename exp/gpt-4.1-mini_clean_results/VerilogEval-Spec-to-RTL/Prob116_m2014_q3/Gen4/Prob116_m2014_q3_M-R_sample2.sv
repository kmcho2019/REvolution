module TopModule(
    input  [3:0] x,
    output      f
);

    // Inputs are x[3:0]
    // Karnaugh map rows = x[3] x[0], columns = x[1] x[2]
    // So LUT index = {x[3], x[0], x[1], x[2]}

    // Reusing the same f values with don't-cares assigned 0 as before.

    // LUT bits indexed by {x3, x0, x1, x2} from 0 to 15:
    // Let's list all 16 combinations and their f values:

    // Index (x3 x0 x1 x2) : f
    // 0000 (0) : d => 0
    // 0001 (1) : 0
    // 0010 (2) : d => 0
    // 0011 (3) : d => 0

    // 0100 (4) : 0
    // 0101 (5) : d => 0
    // 0110 (6) : 1
    // 0111 (7) : 0

    // 1000 (8) : 1
    // 1001 (9) : 1
    // 1010 (10): 0
    // 1011 (11): 0

    // 1100 (12): 1
    // 1101 (13): 1
    // 1110 (14): 0 (d)
    // 1111 (15): 0 (d)

    // Same bit pattern as previously deduced: 16'h3340

    localparam [15:0] LUT = 16'h3340;

    wire [3:0] lut_idx = {x[3], x[0], x[1], x[2]};

    assign f = LUT[lut_idx];

endmodule