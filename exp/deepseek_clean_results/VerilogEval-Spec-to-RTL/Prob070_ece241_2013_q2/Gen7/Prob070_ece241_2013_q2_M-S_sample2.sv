module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (minimal form)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Simplified Product-of-sums
    assign out_pos = ~((~c & ~d) |                 // Covers 0,1,4,5
                     (~a & b & ~c) |               // Covers 6
                     (a & ~b & d) |               // Covers 9,13
                     (a & b & ~c));                // Covers 10,14

endmodule