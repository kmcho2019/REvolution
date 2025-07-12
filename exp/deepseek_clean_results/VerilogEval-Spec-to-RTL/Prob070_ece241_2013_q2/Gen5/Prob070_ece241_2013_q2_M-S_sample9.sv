module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Product-of-sums is just the inverse of SOP
    assign out_pos = ~out_sop;

endmodule