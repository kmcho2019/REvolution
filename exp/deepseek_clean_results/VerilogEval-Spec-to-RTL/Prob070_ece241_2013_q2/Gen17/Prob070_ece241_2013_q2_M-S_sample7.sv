module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (already minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                    (~a & b & c & d) |    // 7
                    (a & b & c & d);      // 15

    // POS implementation as complement of SOP
    assign out_pos = ~out_sop;

endmodule