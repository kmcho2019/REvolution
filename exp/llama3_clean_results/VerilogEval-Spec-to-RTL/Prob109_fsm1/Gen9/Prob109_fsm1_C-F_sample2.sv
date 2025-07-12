module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1; // Reset to state B
        end else begin
            // Use conditional operator for concise next state logic
            out <= (in && out) ? out : !out;
        end
    end

endmodule