module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

always @(*) begin
    out = state; // Directly determine output from state
end

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case({state, in}) // Simplify state transition logic
            2'b00: state <= 1'b1; // A, in=0 -> B
            2'b01: state <= 1'b0; // B, in=0 -> A
            2'b10: state <= 1'b1; // A, in=1 -> A
            2'b11: state <= 1'b1; // B, in=1 -> B
        endcase
    end
end

endmodule