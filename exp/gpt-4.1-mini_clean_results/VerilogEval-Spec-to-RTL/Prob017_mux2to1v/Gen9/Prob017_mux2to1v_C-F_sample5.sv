module Mux2to1_Nbit #(
    parameter WIDTH = 25
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized 2-to-1 mux for efficient combinational logic
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Partition inputs/outputs into 4 chunks of 25 bits each
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : chunk_muxes
            Mux2to1_Nbit #(.WIDTH(25)) chunk_mux (
                .a   (a[25*i +: 25]),
                .b   (b[25*i +: 25]),
                .sel (sel),
                .out (out[25*i +: 25])
            );
        end
    endgenerate
endmodule