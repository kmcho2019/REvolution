module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of the minimal product terms where output is 0
assign out = ~((a & b & c) | (~a & b & ~d) | (a & ~b & c & d));

endmodule