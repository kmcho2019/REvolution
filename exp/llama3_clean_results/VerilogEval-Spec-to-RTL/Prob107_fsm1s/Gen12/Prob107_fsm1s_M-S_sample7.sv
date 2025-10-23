module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter STATE_B = 0, STATE_A = 1;
reg state; // Current state

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset state is B
    end else if (state == STATE_B && in == 0) begin
        state <= STATE_A;
    end else if (state == STATE_A && in == 0) begin
        state <= STATE_B;
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule