module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Single state register with combined output
    reg state;  // 0=B (out=1), 1=A (out=0)

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
            out <= 1'b1;
        end
        else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // State B transitions
                1'b1: state <= in ? 1'b1 : 1'b0;  // State A transitions
            endcase
            out <= ~state;  // Combined output logic
        end
    end

endmodule