module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State representation
    reg current_state;
    wire next_state;

    // State encoding (0=B, 1=A)
    // Combinational next state logic
    assign next_state = reset ? 1'b0 :  // Reset forces state B
                      (current_state ? in : ~in);  // State transition logic

    // Sequential state update
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = ~current_state;  // Output 1 when in state B (0), 0 when in state A (1)

endmodule