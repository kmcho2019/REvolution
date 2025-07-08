module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

wire term1_sop, term2_sop;
wire term1_pos, term2_pos;

// SOP terms
assign term1_sop = b & c & d;       // bcd
assign term2_sop = (~a) & (~b) & c & (~d); // a'b'cd'
assign out_sop = term1_sop | term2_sop;

// POS terms
assign term1_pos = (~b) | (~c) | (~d);       // b' + c' + d'
assign term2_pos = a | b | (~c) | d;         // a + b + c' + d
assign out_pos = term1_pos & term2_pos;

endmodule