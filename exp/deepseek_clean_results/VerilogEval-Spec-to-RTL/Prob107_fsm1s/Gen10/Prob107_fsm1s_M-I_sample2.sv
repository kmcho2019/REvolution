module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Single state register that also drives output
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B (0)
            out <= 1'b1;    // Output 1 in state B
        end else begin
            state <= state ? in : ~in;
            out <= ~(state ? in : ~in);
        end
    end

endmodule