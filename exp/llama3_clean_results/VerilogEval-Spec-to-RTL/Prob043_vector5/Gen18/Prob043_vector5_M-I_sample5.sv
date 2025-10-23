// Define a small, reusable vector comparator module
module VectorComparator(
    input  [4:0] vec,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign out[i] = (vec[i / 5] === vec[i % 5])? 1'b1 : 1'b0;
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

    reg [4:0] vec;
    assign vec = {a, b, c, d, e};
    VectorComparator cmp(vec, out);

endmodule