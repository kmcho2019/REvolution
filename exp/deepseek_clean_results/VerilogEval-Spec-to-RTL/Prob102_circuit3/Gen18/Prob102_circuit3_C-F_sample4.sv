module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Truth table implementation:
    // q = 1 when (a OR b) AND (c OR d)
    // Matches all cases where q=1 in waveform:
    // 0101,0110,0111 (b=1 and c|d)
    // 1001,1010,1011 (a=1 and c|d)
    // 1101,1110,1111 (a=1 and b=1 and c|d)
    assign q = (a | b) & (c | d);

endmodule