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
        case({state, in})
            2'b00: begin state <= 1'b1; out <= 1'b0; end // From A, in=0 -> B
            2'b01: begin state <= 1'b0; out <= 1'b0; end // From A, in=1 -> A
            2'b10: begin state <= 1'b0; out <= 1'b1; end // From B, in=0 -> A
            2'b11: begin state <= 1'b1; out <= 1'b1; end // From B, in=1 -> B
            default: begin state <= 1'bx; out <= 1'bx; end // Should not occur
        endcase
    end
end

endmodule