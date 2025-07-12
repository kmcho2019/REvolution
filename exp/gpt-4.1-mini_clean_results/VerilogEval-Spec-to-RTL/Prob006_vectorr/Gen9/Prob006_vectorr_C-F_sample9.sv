module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Internal generate variable
    genvar i;

    // Construct the reversed vector by concatenating bits in reverse order
    // This uses a generate loop inside a function-like context to keep it concise
    wire [WIDTH-1:0] reversed;
    generate
        // Create a reversed vector by assigning each bit from the opposite input bit
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_rev_loop
            assign reversed[i] = in[WIDTH - 1 - i];
        end
    endgenerate

    assign out = reversed;
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