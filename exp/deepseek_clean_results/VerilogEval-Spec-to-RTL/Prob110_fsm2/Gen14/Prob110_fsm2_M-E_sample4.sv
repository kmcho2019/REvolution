module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding
reg [1:0] state;  // state[0] = OFF, state[1] = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state (one-hot)
    end else begin
        state[0] <= (~state[1] & ~j) | (state[1] & k);  // OFF next state logic
        state[1] <= (~state[1] & j) | (state[1] & ~k);  // ON next state logic
    end
end

// Output is simply the ON state bit
assign out = state[1];

endmodule