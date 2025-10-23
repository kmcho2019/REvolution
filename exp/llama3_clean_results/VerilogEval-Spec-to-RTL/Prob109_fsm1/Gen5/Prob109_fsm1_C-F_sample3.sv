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
            // Simplified state transition logic
            out <= (out == 0)? (in? 0 : 1) : (in? 1 : 0);
        end
    end

endmodule