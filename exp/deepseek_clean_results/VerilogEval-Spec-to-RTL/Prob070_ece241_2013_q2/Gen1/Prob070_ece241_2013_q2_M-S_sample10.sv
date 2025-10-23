module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Common implementation for both SOP and POS since they're identical in this case
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);     // 15 (1111)
    
    assign out_pos = out_sop;  // Same logic works for POS in this case

endmodule