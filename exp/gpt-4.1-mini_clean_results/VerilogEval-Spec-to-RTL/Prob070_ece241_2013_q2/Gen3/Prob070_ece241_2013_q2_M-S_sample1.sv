module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP: output 1 for decimal 2,7,15 only
assign out_sop = (~a & ~b & c & ~d)    // 2
               | (~a & b  & c & d)     // 7
               | (a  & b  & c & d);    // 15

// POS is complement of SOP for correct zeros and ones
assign out_pos = ~out_sop;

endmodule