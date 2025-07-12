module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output [WIDTH-1:0] split_bits
);
    // Directly assign input vector to output vector for bit splitting
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

    // Instantiate reusable BitSplitter submodule to split bits as vector
    BitSplitter #(.WIDTH(3)) splitter (
        .in_vec(vec),
        .split_bits(split_bits)
    );

    // Assign output vector directly from input vector
    assign outv = vec;

    // Assign individual bit outputs from split_bits vector
    assign o0 = split_bits[0];
    assign o1 = split_bits[1];
    assign o2 = split_bits[2];

endmodule