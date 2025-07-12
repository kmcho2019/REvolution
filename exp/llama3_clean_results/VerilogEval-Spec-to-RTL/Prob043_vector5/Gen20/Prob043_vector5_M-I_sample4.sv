// Define a small, reusable vector comparator module
module VectorComparator(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            // Using a straightforward equality check to minimize switching activity
            assign out[i] = (i / 5 == i % 5)? ~(a ^ a) : ~(i / 5 ^ i % 5);
        end
    endgenerate

endmodule

// TopModule utilizing the VectorComparator module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Directly instantiating the VectorComparator module
    VectorComparator cmp(a, b, c, d, e, out);

endmodule