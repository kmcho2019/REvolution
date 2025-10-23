module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // State register using one-hot encoding

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b10; // Reset to OFF state
    end else if (state == 2'b10) begin // Currently in OFF state
        state <= j ? 2'b01 : 2'b10; // Transition to ON if j is 1, stay in OFF otherwise
    end else begin // Currently in ON state
        state <= ~k ? 2'b01 : 2'b10; // Stay in ON if k is 0, transition to OFF otherwise
    end
end

assign out = state[0]; // Output is '1' when state is ON ("01")

endmodule