// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b);
endmodule

// VectorComparator module utilizing the Comparator module
module VectorComparator(
    input  [4:0] vec1,
    input  [4:0] vec2,
    output [24:0] out
);
    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                Comparator cmp(vec1[i], vec2[j], out[(i*5)+j]);
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
    reg [4:0] vec;

    always @(*) begin
        vec = {a, b, c, d, e};
    end

    VectorComparator cmp(vec, vec, out);
endmodule