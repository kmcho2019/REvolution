module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire [1:0] ab = {a,b};
    wire q0, q1, q2, q3;

    // When (a,b) = 00
    // q = 1 only when c=0,d=0 or c=1,d=1 (from waveform at 0ns,30ns)
    // This can be expressed as (c ~^ d) & ~(a|b), but since we select by ab, q0 = ~(c|d) | (c & d)
    // Simplify: q0 = (~c & ~d) | (c & d) = c ~^ d (XNOR)
    assign q0 = ~(c ^ d);

    // When (a,b) = 01
    // From the waveform, q is 1 for (0,1) and (1,0), zero for (0,0) and (1,1)
    // This is the XOR of c and d
    assign q1 = c ^ d;

    // When (a,b) = 10
    // For (a,b)=10, from waveform q is 1 for (c,d) = (0,1), (1,0), zero for (0,0) and (1,1)
    // Same as q1, so q2 = c ^ d
    assign q2 = c ^ d;

    // When (a,b) = 11
    // For (a,b)=11, q=1 only when c=1 and d=1 (from 90ns)
    assign q3 = c & d;

    // 4-to-1 MUX based on (a,b)
    assign q = (ab == 2'b00) ? q0 :
               (ab == 2'b01) ? q1 :
               (ab == 2'b10) ? q2 :
                               q3;

endmodule