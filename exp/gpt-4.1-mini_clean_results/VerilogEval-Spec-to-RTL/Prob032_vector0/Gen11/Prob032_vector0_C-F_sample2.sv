module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output [WIDTH-1:0] bits
);
    // Directly assign output bits equal to input vector bits
    assign bits = in_vec;
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Assign the output vector directly from input vector for minimal logic
    assign outv = vec;

    // Use BitSplitter to split bits into an unpacked bus, minimizing hierarchy
    wire [2:0] split_bits;
    BitSplitter #(3) splitter (
        .in_vec(vec),
        .bits(split_bits)
    );

    // Connect individual outputs to corresponding bits from split_bits
    assign o0 = split_bits[0];
    assign o1 = split_bits[1];
    assign o2 = split_bits[2];

endmodule