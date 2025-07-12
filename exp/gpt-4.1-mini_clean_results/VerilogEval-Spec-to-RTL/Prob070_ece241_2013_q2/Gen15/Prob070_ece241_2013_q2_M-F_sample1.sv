module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP: outputs=1 at 2,7,15 (minterms)
    // 2  = ~a & ~b & c & ~d
    // 7  = ~a & b & c & d
    // 15 = a & b & c & d
    assign out_sop = 
        (~a & ~b &  c & ~d) |
        (~a &  b &  c &  d) |
        ( a &  b &  c &  d);

    // POS output as complement of SOP output
    assign out_pos = ~out_sop;

endmodule