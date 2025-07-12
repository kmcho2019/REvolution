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
    end else if (state == 0 && in == 0) begin
        state <= 1; // Transition from B to A when in is 0
    end else if (state == 1 && in == 0) begin
        state <= 0; // Transition from A to B when in is 0
    end // Otherwise, stay in the current state
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule