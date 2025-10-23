module BitMux2to1_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       sel,
    output wire [3:0] out
);
    assign out = sel ? b : a;
endmodule

module BitMux2to1_Nbit #(
    parameter WIDTH = 4
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Pad inputs to 128 bits (next power of two)
    wire [127:0] a_padded = {28'b0, a};
    wire [127:0] b_padded = {28'b0, b};

    // Stage 1: 4-bit muxes (32 muxes of 4 bits = 128 bits)
    wire [127:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : stage1
            BitMux2to1_4bit mux4 (
                .a(a_padded[i*4 +: 4]),
                .b(b_padded[i*4 +: 4]),
                .sel(sel),
                .out(stage1_out[i*4 +: 4])
            );
        end
    endgenerate

    // Stage 2: 8 muxes of 16 bits (combine pairs of stage1 muxes)
    wire [127:0] stage2_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            BitMux2to1_Nbit #(16) mux16 (
                .a(stage1_out[i*16 +: 16]),
                .b(stage1_out[(i+8)*16 +: 16]),
                .sel(sel),
                .out(stage2_out[i*16 +: 16])
            );
        end
    endgenerate

    // Stage 3: 4 muxes of 32 bits (combine pairs of stage2 muxes)
    wire [127:0] stage3_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3
            BitMux2to1_Nbit #(32) mux32 (
                .a(stage2_out[i*32 +: 32]),
                .b(stage2_out[(i+4)*32 +: 32]),
                .sel(sel),
                .out(stage3_out[i*32 +: 32])
            );
        end
    endgenerate

    // Stage 4: 2 muxes of 64 bits (combine pairs of stage3 muxes)
    wire [127:0] stage4_out;
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4
            BitMux2to1_Nbit #(64) mux64 (
                .a(stage3_out[i*64 +: 64]),
                .b(stage3_out[(i+2)*64 +: 64]),
                .sel(sel),
                .out(stage4_out[i*64 +: 64])
            );
        end
    endgenerate

    // Final stage: 1 mux of 128 bits (combine pairs of stage4 muxes)
    wire [127:0] final_out;
    BitMux2to1_Nbit #(128) mux128 (
        .a(stage4_out[0 +: 128]),
        .b(stage4_out[64 +: 128]),
        .sel(sel),
        .out(final_out)
    );

    // Truncate to 100 bits output
    assign out = final_out[27 +: 100];
endmodule