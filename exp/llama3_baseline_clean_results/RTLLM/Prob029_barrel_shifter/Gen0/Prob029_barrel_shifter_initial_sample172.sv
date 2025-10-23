// 2-to-1 Multiplexer submodule
module mux2X1(
    input   sel,
    input   a,
    input   b,
    output  out
);
    assign out = sel? b : a;
endmodule

// Barrel Shifter module
module barrel_shifter(
    input   [7:0] in,
    input   [2:0] ctrl,
    output  [7:0] out
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    for (genvar i = 0; i < 8; i++) begin
        mux2X1 stage1_mux(
           .sel(ctrl[2]),
           .a(in[i]),
           .b(i < 4? 1'b0 : in[i-4]),
           .out(stage1_out[i])
        );
    end

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    for (genvar i = 0; i < 8; i++) begin
        mux2X1 stage2_mux(
           .sel(ctrl[1]),
           .a(stage1_out[i]),
           .b(i < 2? 1'b0 : stage1_out[i-2]),
           .out(stage2_out[i])
        );
    end

    // Stage 3: Shift by 1 position if ctrl[0] is high
    for (genvar i = 0; i < 8; i++) begin
        mux2X1 stage3_mux(
           .sel(ctrl[0]),
           .a(stage2_out[i]),
           .b(i < 1? 1'b0 : stage2_out[i-1]),
           .out(out[i])
        );
    end

endmodule