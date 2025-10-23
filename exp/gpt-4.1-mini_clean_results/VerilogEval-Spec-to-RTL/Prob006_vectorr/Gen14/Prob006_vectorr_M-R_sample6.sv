module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse_assign
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate
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