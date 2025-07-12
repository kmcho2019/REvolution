module BitReverser #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    // Use a single concatenation assign to reverse bits efficiently
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
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