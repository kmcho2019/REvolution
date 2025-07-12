// 2-to-1 multiplexer submodule
module mux2X1(
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

// 8-bit barrel shifter with 3-stage cascaded shifting
module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out;  // After 4-bit shift
    wire [7:0] stage2_out;  // After 2-bit shift
    
    // Stage 1: 4-bit shift controlled by ctrl[2]
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1
            mux2X1 mux_stage1(
                .a(in[i]), 
                .b(in[(i+4)%8]), 
                .sel(ctrl[2]), 
                .out(stage1_out[i])
            );
        end
    endgenerate
    
    // Stage 2: 2-bit shift controlled by ctrl[1]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            mux2X1 mux_stage2(
                .a(stage1_out[i]), 
                .b(stage1_out[(i+2)%8]), 
                .sel(ctrl[1]), 
                .out(stage2_out[i])
            );
        end
    endgenerate
    
    // Stage 3: 1-bit shift controlled by ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3
            mux2X1 mux_stage3(
                .a(stage2_out[i]), 
                .b(stage2_out[(i+1)%8]), 
                .sel(ctrl[0]), 
                .out(out[i])
            );
        end
    endgenerate
endmodule