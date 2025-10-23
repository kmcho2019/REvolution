module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum SOP expression
assign out_sop = (b & ~c & ~d) | (~b & c & d) | (a & b & c & d);

// Minimum POS expression
assign out_pos = ~( (a | b | c | d) & (a | b | ~c | d) & (a | ~b | c | d) & (a | ~b | c | ~d) & 
                   (~a | b | c | ~d) & (~a | b | c | d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) );

endmodule