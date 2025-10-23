module TopModule(
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
            // Use a multiplexer-like approach to select the next output
            case (out)
                1'b0: // State A
                    out <= in ? 1'b0 : 1'b1; // Stay in A on input 1, transition to B on input 0
                1'b1: // State B
                    out <= in ? 1'b1 : 1'b0; // Stay in B on input 1, transition to A on input 0
            endcase
        end
    end

endmodule