module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Pre-compute all possible rotations
    wire [7:0] rot[0:7];
    assign rot[0] = in;                            // 0 positions
    assign rot[1] = {in[0], in[7:1]};             // 1 position
    assign rot[2] = {in[1:0], in[7:2]};           // 2 positions
    assign rot[3] = {in[2:0], in[7:3]};           // 3 positions
    assign rot[4] = {in[3:0], in[7:4]};           // 4 positions
    assign rot[5] = {in[4:0], in[7:5]};           // 5 positions
    assign rot[6] = {in[5:0], in[7:6]};           // 6 positions
    assign rot[7] = {in[6:0], in[7]};             // 7 positions

    // First level mux: ctrl[2] selects between groups
    wire [7:0] mux_l1 = ctrl[2] ? (ctrl[1] ? (ctrl[0] ? rot[7] : rot[6]) : 
                                       (ctrl[0] ? rot[5] : rot[4])
                                : (ctrl[1] ? (ctrl[0] ? rot[3] : rot[2]) : 
                                       (ctrl[0] ? rot[1] : rot[0]));

    // Final output
    assign out = mux_l1;

endmodule