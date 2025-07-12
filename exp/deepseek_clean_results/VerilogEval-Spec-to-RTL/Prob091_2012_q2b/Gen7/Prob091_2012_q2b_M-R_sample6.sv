module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @* begin
    // Y1 is the next state for y[1] (state B)
    Y1 = y[0] & w;  // Transition from A to B when w=1
    
    // Y3 is the next state for y[3] (state D)
    Y3 = ~w & ~y[0] & ~y[3];  // Transitions to D from various states when w=0
end

endmodule