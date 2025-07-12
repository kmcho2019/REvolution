module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// Single flip-flop for one-hot state: 0 = A, 1 = B
reg state, next_state;

// Next state logic (combinational)
always @(*) begin
    if (state == 1'b0) begin
        // From A: if x=0 stay in A (0), if x=1 go to B (1)
        next_state = x ? 1'b1 : 1'b0;
    end else begin
        // From B: always stay in B
        next_state = 1'b1;
    end
end

// Output logic (Mealy FSM)
always @(*) begin
    if (state == 1'b0) begin
        // A: z= x
        z = x;
    end else begin
        // B: z= ~x
        z = ~x;
    end
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 1'b0; // Reset to A
    else
        state <= next_state;
end

endmodule