// Define the 2-to-1 multiplexer submodule
module mux2X1(sel, a, b, out);
    input sel, a, b;
    output out;
    assign out = sel ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage1(.sel(ctrl[2]), .a(in[i]), .b(in[(i+4)%8]), .out(stage1_out[i]));
        end
    endgenerate
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage2(.sel(ctrl[1]), .a(stage1_out[i]), .b(stage1_out[(i+2)%8]), .out(stage2_out[i]));
        end
    endgenerate
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage3(.sel(ctrl[0]), .a(stage2_out[i]), .b(stage2_out[(i+1)%8]), .out(out[i]));
        end
    endgenerate
endmodule