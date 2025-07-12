module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // For WIDTH=8, use explicit concatenation of bits reversed
    // For scalability, can add if-def or generate, but here optimized for WIDTH=8 use case
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
endmodule

module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    BitReverser #(.WIDTH(8)) reverser_inst (
        .in(in),
        .out(out)
    );
endmodule