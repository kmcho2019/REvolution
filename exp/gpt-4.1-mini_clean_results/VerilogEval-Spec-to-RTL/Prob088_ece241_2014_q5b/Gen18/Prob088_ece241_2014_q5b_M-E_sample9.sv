module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (combinational)
always @(*) begin
    // From A: if x=0 stay in A, else go to B
    if (state_A) begin
        next_state_A = ~x;
        next_state_B = x;
    end
    // From B: stay in B regardless of x
    else begin
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy): 
// In state A: z = x
// In state B: z = ~x
always @(*) begin
    if (state_A)
        z = x;
    else
        z = ~x;
end

endmodule