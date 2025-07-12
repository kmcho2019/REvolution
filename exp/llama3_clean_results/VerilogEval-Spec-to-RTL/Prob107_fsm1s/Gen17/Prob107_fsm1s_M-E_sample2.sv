module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state B (out = 1)
        out <= 1'b1;
    end else begin
        if (~in) begin // If in is 0
            state <= ~state; // Toggle state
        end
        out <= ~state; // Output is inverse of state
    end
end

endmodule