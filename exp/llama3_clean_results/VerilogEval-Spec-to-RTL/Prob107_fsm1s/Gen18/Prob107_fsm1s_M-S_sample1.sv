module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable, defaults to 0 (STATE_B)

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state B
    end else begin
        state <= in ? state : ~state; // Simplified state transition logic
    end
end

assign out = ~state; // Output directly related to the state

endmodule