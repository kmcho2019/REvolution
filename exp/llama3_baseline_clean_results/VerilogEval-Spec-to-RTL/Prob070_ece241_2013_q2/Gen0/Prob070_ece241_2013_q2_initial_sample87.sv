module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);
assign out_pos = (~a|b) & (a|~b|~c) & (~a|~b|c) & (a|~d) & (~a|b|~d) & (~a|c|d);

endmodule