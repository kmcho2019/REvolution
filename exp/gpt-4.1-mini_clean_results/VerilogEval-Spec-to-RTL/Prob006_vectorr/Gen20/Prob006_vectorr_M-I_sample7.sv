module BitReverser #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    // Correct bit reversal by reversing the bit indices in concatenation
    assign out = {in[WIDTH-1], in[WIDTH-2], in[WIDTH-3], in[WIDTH-4], in[WIDTH-5], in[WIDTH-6], in[WIDTH-7], in[0]};
endmodule

module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    BitReverser #(.WIDTH(8)) reverser_inst (
        .in(in),
        .out(out)
    );
endmodule