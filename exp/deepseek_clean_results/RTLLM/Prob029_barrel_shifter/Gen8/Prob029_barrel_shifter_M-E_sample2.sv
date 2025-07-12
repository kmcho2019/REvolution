module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Precompute all possible rotated versions
    wire [7:0] rot[0:7];
    assign rot[0] = in;
    assign rot[1] = {in[0], in[7:1]};
    assign rot[2] = {in[1:0], in[7:2]};
    assign rot[3] = {in[2:0], in[7:3]};
    assign rot[4] = {in[3:0], in[7:4]};
    assign rot[5] = {in[4:0], in[7:5]};
    assign rot[6] = {in[5:0], in[7:6]};
    assign rot[7] = {in[6:0], in[7]};

    // Hierarchical multiplexer structure
    wire [7:0] level1_out;
    wire [7:0] level2_out;

    // Level 1: ctrl[2] selects between 0-3 or 4-7 shifts
    assign level1_out = ctrl[2] ? (ctrl[1] ? (ctrl[0] ? rot[7] : rot[6])
                                       : (ctrl[0] ? rot[5] : rot[4]))
                          : (ctrl[1] ? (ctrl[0] ? rot[3] : rot[2])
                                       : (ctrl[0] ? rot[1] : rot[0]));

    // Final output
    assign out = level1_out;
endmodule