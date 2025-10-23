module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Internal mux2X1 module definition
    module mux2X1(
        input [7:0] in0,
        input [7:0] in1,
        input sel,
        output [7:0] out
    );
        assign out = sel ? in1 : in0;
    endmodule

    // Shift operations
    wire [7:0] shift1 = {in[6:0], in[7]};    // 1-bit rotate right
    wire [7:0] shift2 = {in[5:0], in[7:6]};  // 2-bit rotate right
    wire [7:0] shift4 = {in[3:0], in[7:4]};  // 4-bit rotate right
    
    // Intermediate connections
    wire [7:0] stage1_out, stage2_out;
    
    // Shift stages (order: 1→2→4)
    mux2X1 mux_stage1 (.in0(in), .in1(shift1), .sel(ctrl[0]), .out(stage1_out));
    mux2X1 mux_stage2 (.in0(stage1_out), .in1(shift2), .sel(ctrl[1]), .out(stage2_out));
    mux2X1 mux_stage3 (.in0(stage2_out), .in1(shift4), .sel(ctrl[2]), .out(out));
endmodule