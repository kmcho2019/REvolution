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
            // Use a multiplexer to select the next output
            out <= (in && out) || (!in &&!out);
        end
    end

endmodule