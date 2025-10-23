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
        if (state == 0) begin // Current state is B
            state <= ~in; // State B with in=0, go to state A; State B with in=1, stay in state B
        end else begin // Current state is A
            state <= in; // State A with in=0, go to state B; State A with in=1, stay in state A
        end
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule