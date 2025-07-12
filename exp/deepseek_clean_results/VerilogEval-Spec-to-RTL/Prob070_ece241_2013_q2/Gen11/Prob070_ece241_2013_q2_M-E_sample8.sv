module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation using multiplexer concept
    assign out_sop = c & (
                     (~a & ~b & ~d) |  // Case 2 (0010)
                     (~a & b & d) |     // Case 7 (0111)
                     (a & b & d)        // Case 15 (1111)
                    );

    // Product-of-sums implementation using inverted logic
    assign out_pos = ~(
                     (~c) |             // Covers all c=0 cases
                     (c & ~(~a & ~b & ~d) & ~(~a & b & d) & ~(a & b & d))
                    );

endmodule