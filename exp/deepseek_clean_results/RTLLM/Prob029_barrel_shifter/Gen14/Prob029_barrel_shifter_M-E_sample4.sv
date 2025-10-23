module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Level 1: 4-bit rotation mux (controlled by ctrl[2])
    wire [7:0] mux_l1_0 = in;                    // No shift
    wire [7:0] mux_l1_1 = {in[3:0], in[7:4]};    // 4-bit rotate right
    wire [7:0] level1 = ctrl[2] ? mux_l1_1 : mux_l1_0;

    // Level 2: 2-bit rotation mux (controlled by ctrl[1])
    wire [7:0] mux_l2_0 = level1;                // No shift
    wire [7:0] mux_l2_1 = {level1[1:0], level1[7:2]}; // 2-bit rotate right
    wire [7:0] level2 = ctrl[1] ? mux_l2_1 : mux_l2_0;

    // Level 3: 1-bit rotation mux (controlled by ctrl[0])
    wire [7:0] mux_l3_0 = level2;                // No shift
    wire [7:0] mux_l3_1 = {level2[0], level2[7:1]}; // 1-bit rotate right
    assign out = ctrl[0] ? mux_l3_1 : mux_l3_0;
endmodule