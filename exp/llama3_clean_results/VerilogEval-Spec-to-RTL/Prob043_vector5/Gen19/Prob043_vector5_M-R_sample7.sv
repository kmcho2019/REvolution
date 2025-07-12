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
            // Simplify comparison when comparing with itself
            if (i / 5 == i % 5) begin
                assign out[i] = 1'b1;
            end else begin
                // Use direct comparison for simplicity and potential optimization
                assign out[i] = (a, b, c, d, e)[i / 5] === (a, b, c, d, e)[i % 5] ? 1'b1 : 1'b0;
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

    // Directly instantiate VectorComparator with input signals
    VectorComparator cmp(a, b, c, d, e, out);

endmodule