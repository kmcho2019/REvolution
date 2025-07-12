module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to B
            out <= 1'b1;    // Output for state B
        end else begin
            state <= state ? in : ~in;  // Combined state transition logic
            out <= ~(state ? in : ~in); // Next state output
        end
    end

endmodule