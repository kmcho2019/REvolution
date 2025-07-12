module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot encoded states: state_A and state_B
    reg state_A, state_B;

    // Next state signals (combinational logic)
    wire next_state_A = state_A & ~x;
    wire next_state_B = state_B | (state_A & x);

    // Asynchronous active-high reset, state flip-flops with non-blocking assignments
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Mealy output: z = (state_A & x) | (state_B & ~x)
    always @(*) begin
        z = (state_A & x) | (state_B & ~x);
    end

endmodule