// Define a small, reusable vector comparator module
module VectorComparator(
    input  [4:0] vec1,
    input  [4:0] vec2,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            // Using a straightforward equality check to minimize switching activity
            assign out[i] = (vec1[i / 5] == vec2[i % 5])? 1'b1 : 1'b0;
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

    // Directly assigning inputs to the VectorComparator module
    VectorComparator cmp({a, b, c, d, e}, {a, b, c, d, e}, out);

endmodule