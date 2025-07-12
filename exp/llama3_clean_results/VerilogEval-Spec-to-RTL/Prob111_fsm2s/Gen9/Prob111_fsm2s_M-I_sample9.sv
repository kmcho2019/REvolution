module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (state == 1'b0 && j == 1'b1) begin
        state <= 1'b1; // Transition from OFF to ON if j=1
    end else if (state == 1'b1 && k == 1'b1) begin
        state <= 1'b0; // Transition from ON to OFF if k=1
    end
end

assign out = state; // Assign output based on state

endmodule