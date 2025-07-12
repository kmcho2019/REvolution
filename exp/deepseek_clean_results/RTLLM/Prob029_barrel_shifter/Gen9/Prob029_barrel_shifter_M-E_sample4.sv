module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Pre-compute all possible shift amounts
    wire [7:0] shift0 = in;
    wire [7:0] shift1 = {in[6:0], in[7]};
    wire [7:0] shift2 = {in[5:0], in[7:6]};
    wire [7:0] shift3 = {in[4:0], in[7:5]};
    wire [7:0] shift4 = {in[3:0], in[7:4]};
    wire [7:0] shift5 = {in[2:0], in[7:3]};
    wire [7:0] shift6 = {in[1:0], in[7:2]};
    wire [7:0] shift7 = {in[0], in[7:1]};

    // Hierarchical multiplexer tree
    wire [7:0] stage1 = ctrl[2] ? shift4 : shift0;
    wire [7:0] stage2 = ctrl[1] ? (ctrl[2] ? shift6 : shift2) : stage1;
    wire [7:0] stage3 = ctrl[0] ? (ctrl[2:1] == 2'b00 ? shift1 : 
                                  ctrl[2:1] == 2'b01 ? shift3 :
                                  ctrl[2:1] == 2'b10 ? shift5 : shift7) : stage2;

    assign out = stage3;
endmodule