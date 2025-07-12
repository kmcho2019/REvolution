module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state (0 for B, 1 for A)

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B
    end else begin
        state <= (state == 0)? (in == 0)? 1 : 0 : (in == 0)? 0 : 1;
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule