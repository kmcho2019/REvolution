module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Compute all possible shifts in parallel
    wire [7:0] shift1 = {in[0], in[7:1]};      // 1-bit rotate right
    wire [7:0] shift2 = {in[1:0], in[7:2]};    // 2-bit rotate right
    wire [7:0] shift4 = {in[3:0], in[7:4]};    // 4-bit rotate right

    // Combine shifts based on control signals
    wire [7:0] stage1 = ctrl[0] ? shift1 : in;
    wire [7:0] stage2 = ctrl[1] ? shift2 : stage1;
    wire [7:0] stage3 = ctrl[2] ? shift4 : stage2;

    assign out = stage3;
endmodule