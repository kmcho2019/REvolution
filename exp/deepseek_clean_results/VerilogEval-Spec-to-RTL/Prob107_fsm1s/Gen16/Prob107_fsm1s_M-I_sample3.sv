module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    // State storage and output
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = state ? in : ~in;

    // State register with synchronous reset and registered output
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
            out <= 1'b1;  // Reset output matches STATE_B output
        end
        else begin
            state <= next_state;
            out <= (next_state == STATE_B);  // Output based on next state
        end
    end

endmodule