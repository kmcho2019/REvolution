module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Reverse bits by concatenating input bits in reverse order
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