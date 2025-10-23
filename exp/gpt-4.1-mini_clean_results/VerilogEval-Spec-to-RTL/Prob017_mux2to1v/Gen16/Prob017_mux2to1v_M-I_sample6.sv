module Mux2to1Chunked #(
    parameter WIDTH = 10
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
    genvar i;
    generate
        for (i=0; i < 10; i=i+1) begin : mux_chunks
            Mux2to1Chunked #(.WIDTH(10)) chunk_mux (
                .a   (a[(i+1)*10-1 : i*10]),
                .b   (b[(i+1)*10-1 : i*10]),
                .sel (sel),
                .out (out[(i+1)*10-1 : i*10])
            );
        end
    endgenerate
endmodule