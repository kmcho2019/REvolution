module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_Q;  // 0=A, 1=B

    // Optimized next state logic
    wire next_state = state_Q | (x & ~state_Q);

    // Efficient output logic - XOR implements the required behavior
    assign z = state_Q ^ x;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_Q <= 1'b0;  // Reset to state A
        end
        else begin
            state_Q <= next_state;
        end
    end

endmodule