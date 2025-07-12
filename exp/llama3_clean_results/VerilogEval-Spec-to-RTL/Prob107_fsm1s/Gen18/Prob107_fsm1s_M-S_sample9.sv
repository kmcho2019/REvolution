module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        if (~in) begin
            state <= ~state; // Update state based on input
        end
    end
end

assign out = state; // Directly assign output based on state

endmodule