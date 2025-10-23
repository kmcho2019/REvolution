module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR using individual OR gates
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bitwise_or
            or g1(out_or_bitwise[i], a[i], b[i]);
        end
    endgenerate

    // Logical OR implemented by OR-ing all bits together
    wire [5:0] all_bits = {a, b};
    wire [4:0] or_tree;
    or g2(or_tree[0], all_bits[0], all_bits[1]);
    or g3(or_tree[1], all_bits[2], all_bits[3]);
    or g4(or_tree[2], all_bits[4], all_bits[5]);
    or g5(or_tree[3], or_tree[0], or_tree[1]);
    or g6(out_or_logical, or_tree[3], or_tree[2]);

    // NOT operations using explicit inverters
    generate
        for (i = 0; i < 3; i = i + 1) begin : not_gates
            not inv1(out_not[i+3], b[i]);    // Upper bits: ~b
            not inv2(out_not[i], a[i]);      // Lower bits: ~a
        end
    endgenerate

endmodule