module mux2X1(
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    
    // Stage 1: Shift by 4 if ctrl[2] is set
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
    
    // Stage 2: Shift by 2 if ctrl[1] is set
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
    
    // Stage 3: Shift by 1 if ctrl[0] is set
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