module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y2 corresponds to state B, which is y[1]
assign Y2 = (y[0] && !w); // A (000001) to B (000010) when w = 0

// Y4 corresponds to state D, which is y[3]
assign Y4 = (!w[0] && y[1] && w) || // B to D
           (!w[0] && y[2] && w) || // C to D
           (!w[0] && y[4] && w);   // E to D

// For completeness, including the assignment for Y1 and Y3 as per the original problem statement
assign Y1 = y[0]; // Since state A is represented by y[0] = 1
assign Y3 = y[2]; // Since the problem statement asks for Y3 but the logic provided focuses on Y2 and Y4

endmodule