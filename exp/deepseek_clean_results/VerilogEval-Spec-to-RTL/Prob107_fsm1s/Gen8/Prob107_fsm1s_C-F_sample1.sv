module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding (output is directly state)
    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1; // State B (output 1)
        end else begin
            case (out)
                1'b1: out <= in ? 1'b1 : 1'b0; // State B transitions
                1'b0: out <= in ? 1'b0 : 1'b1; // State A transitions
            endcase
        end
    end

endmodule