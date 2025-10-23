module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin // State A
                if(in == 1'b0) begin
                    state <= 1'b1; // From A, in=0 -> B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // From A, in=1 -> A
                    out <= 1'b0;
                end
            end
            1'b1: begin // State B
                if(in == 1'b0) begin
                    state <= 1'b0; // From B, in=0 -> A
                    out <= 1'b0;
                end else begin
                    state <= 1'b1; // From B, in=1 -> B
                    out <= 1'b1;
                end
            end
            default: state <= 1'bx; out <= 1'bx; // Should not occur
        endcase
    end
end

endmodule