module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

assign out = state; // Directly determine output based on state

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case({state, in})
            2'b00: state <= 1'b1; // From A, in=0 -> B
            2'b01: state <= 1'b0; // From A, in=1 -> A
            2'b10: state <= 1'b0; // From B, in=0 -> A
            2'b11: state <= 1'b1; // From B, in=1 -> B
            default: state <= 1'bx; // Should not occur
        endcase
    end
end

endmodule