module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Correct bit reversal: reverse input bits order
    assign out = {in[WIDTH-1], in[WIDTH-2], in[WIDTH-3], in[WIDTH-4],
                  in[WIDTH-5], in[WIDTH-6], in[WIDTH-7], in[0]};
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