module Mux2to1_Nbit #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_mux
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate
endmodule

module ChunkMux2to1_10bit (
    input  wire [9:0] a,
    input  wire [9:0] b,
    input  wire       sel,
    output wire [9:0] out
);
    // Use bitwise mux inside chunk for synthesis efficiency
    Mux2to1_Nbit #(.WIDTH(10)) u_mux (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_muxes
            ChunkMux2to1_10bit chunk_mux_inst (
                .a   (a[i*10 +: 10]),
                .b   (b[i*10 +: 10]),
                .sel (sel),
                .out (out[i*10 +: 10])
            );
        end
    endgenerate
endmodule