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
        case(state)
            0: state <= in; // Transition from B
            1: state <= ~in; // Transition from A
        endcase
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule