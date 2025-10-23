// Define a small, reusable vector comparator module
module VectorComparator(
    input  [4:0] vec,
    output [24:0] out
);

    genvar i;
    genvar j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                assign out[i * 5 + j] = ~(vec[i] ^ vec[j]);
            end
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

    VectorComparator cmp({a, b, c, d, e}, out);

endmodule