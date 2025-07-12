module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// out_sop is 1 when the inputs are 2, 7, or 15
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// out_pos is 1 when the inputs are 2, 7, or 15
assign out_pos = ~( (~b | a | c | d) & (~b | ~a | ~c | ~d) & (~b | ~a | ~c | d) & (~b | ~a | c | ~d) & (~b | ~a | c | d) & (~b | a | ~c | ~d) & (~b | a | ~c | d) & (b | ~a | ~c | ~d) & (b | ~a | ~c | d) & (b | ~a | c | ~d) );

endmodule