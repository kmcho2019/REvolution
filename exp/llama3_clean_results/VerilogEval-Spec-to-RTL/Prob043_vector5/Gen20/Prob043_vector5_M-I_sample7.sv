// Define a small, reusable vector comparator module
module VectorComparator(
    input  [4:0] vec1,
    input  [4:0] vec2,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign out[i] = ~(vec1[i / 5] ^ vec2[i % 5]);
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

    // Directly connect inputs to the comparator module
    VectorComparator cmp({a, b, c, d, e}, {a, b, c, d, e}, out);

endmodule