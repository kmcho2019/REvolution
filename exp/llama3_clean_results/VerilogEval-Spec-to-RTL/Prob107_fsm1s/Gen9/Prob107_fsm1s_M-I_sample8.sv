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
        state <= ~in & ~state | in & state; // Simplified state transition logic using bitwise operations
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule