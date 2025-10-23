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
            // Simplified next state logic using current output and input
            out <= (out && in) || (!out && !in);
        end
    end

endmodule