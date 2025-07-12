module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state B (0)
    end else begin
        case({state, in})
            2'b00: state <= 1'b1; // State B (0) and input 0, go to state A (1)
            2'b01: state <= 1'b0; // State B (0) and input 1, stay in state B (0)
            2'b10: state <= 1'b0; // State A (1) and input 0, go to state B (0)
            2'b11: state <= 1'b1; // State A (1) and input 1, stay in state A (1)
            default: state <= 1'b0; // Default to state B (0) for invalid states
        endcase
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule