module TopModule (
    input clk,
    input areset,
    input in,
    output reg out = 1'b1  // Default to state B (1)
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b1;  // Async reset to state B (1)
        end else begin
            case (out)
                1'b0: out <= in ? 1'b0 : 1'b1;  // State A transitions
                1'b1: out <= in ? 1'b1 : 1'b0;  // State B transitions
            endcase
        end
    end

endmodule