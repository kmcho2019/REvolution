module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output [WIDTH-1:0] bits_out
);
    assign bits_out = in_vec;
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Assign outv directly from vec for minimal logic
    assign outv = vec;

    // Use BitSplitter to extract all bits as a vector
    wire [2:0] splitted_bits;
    BitSplitter #(3) splitter (
        .in_vec(vec),
        .bits_out(splitted_bits)
    );

    // Connect each bit output individually from the splitter's vector output
    assign o0 = splitted_bits[0];
    assign o1 = splitted_bits[1];
    assign o2 = splitted_bits[2];

endmodule