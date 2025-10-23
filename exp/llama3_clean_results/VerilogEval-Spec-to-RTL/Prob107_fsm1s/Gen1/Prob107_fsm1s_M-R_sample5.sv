module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        case({state, in})
            2'b00: state <= 1; // State B with in=0, go to state A
            2'b01: state <= 0; // State B with in=1, stay in state B
            2'b10: state <= 0; // State A with in=0, go to state B
            2'b11: state <= 1; // State A with in=1, stay in state A
        endcase
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule