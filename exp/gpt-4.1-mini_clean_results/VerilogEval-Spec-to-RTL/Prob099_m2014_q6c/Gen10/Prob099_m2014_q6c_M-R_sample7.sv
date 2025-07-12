module TopModule (
    input  [5:0] y,  // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output reg   Y1, // Next-state signal corresponding to y[1] (state B)
    output reg   Y3  // Next-state signal corresponding to y[3] (state D)
);

always @(*) begin
    // Next state B (y[1]) active when in state A with input=0
    Y1 = y[0] & ~w;

    // Next state D (y[3]) active when in states B, C, D, E, or F with input=1
    Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);
end

endmodule