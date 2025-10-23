module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state;  // one-hot: bit[0] = OFF, bit[1] = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state (one-hot)
    end else begin
        // Next state logic
        state[0] <= (state[0] & ~j) | (state[1] & k);
        state[1] <= (state[0] & j) | (state[1] & ~k);
    end
end

assign out = state[1];  // Output is ON state bit

endmodule