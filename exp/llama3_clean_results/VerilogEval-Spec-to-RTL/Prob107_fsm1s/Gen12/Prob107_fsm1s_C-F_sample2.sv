module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1; // Output is 1 in state B
    end else begin
        state <= in? state : ~state; // Update state based on input
        out <= state; // Output is directly related to the state
    end
end

endmodule