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
            if (out == 0) begin // Current state is A
                out <= in? 0 : 1; // Transition based on input
            end else begin // Current state is B
                out <= in? 1 : 0; // Transition based on input
            end
        end
    end

endmodule