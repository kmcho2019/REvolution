module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Compute shifted versions
    wire [7:0] shifted4 = {in[3:0], in[7:4]};  // 4-bit rotate right
    wire [7:0] shifted2 = {in[1:0], in[7:2]};  // 2-bit rotate right
    wire [7:0] shifted1 = {in[0],   in[7:1]};  // 1-bit rotate right

    // Apply shifts in correct priority order (4->2->1)
    assign out = ctrl[2] ? shifted4 :
                 ctrl[1] ? shifted2 :
                 ctrl[0] ? shifted1 : in;
endmodule