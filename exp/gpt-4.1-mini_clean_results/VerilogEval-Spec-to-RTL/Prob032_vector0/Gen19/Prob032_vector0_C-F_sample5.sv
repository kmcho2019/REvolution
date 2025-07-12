module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output [WIDTH-1:0] split_bits
);
    // Directly output the input vector as split bits for simplicity and reusability
    assign split_bits = in_vec;
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    wire [2:0] split_bits;

    // Instantiate BitSplitter with vector output to minimize ports and complexity
    BitSplitter #(.WIDTH(3)) splitter (
        .in_vec(vec),
        .split_bits(split_bits)
    );

    // Pass input vector directly to output vector
    assign outv = vec;

    // Assign individual bits from split_bits vector to outputs
    assign o0 = split_bits[0];
    assign o1 = split_bits[1];
    assign o2 = split_bits[2];

endmodule