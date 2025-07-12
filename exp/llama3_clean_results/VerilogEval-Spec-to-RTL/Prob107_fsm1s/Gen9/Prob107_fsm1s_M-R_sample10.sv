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
        if(state == 0) begin
            state <= in ? 0 : 1; // State transition from B
        end else begin
            state <= in ? 1 : 0; // State transition from A
        end
    end
end

always @(state) begin
    if(state == 0) begin
        out <= 1; // Output in state B (0)
    end else begin
        out <= 0; // Output in state A (1)
    end
end

endmodule