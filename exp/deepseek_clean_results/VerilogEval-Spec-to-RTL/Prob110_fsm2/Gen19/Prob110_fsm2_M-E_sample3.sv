module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding
reg [1:0] state;  // state[0] = OFF, state[1] = ON

// Combinational next state logic
wire next_OFF = (state[0] & ~j) | (state[1] & k);
wire next_ON  = (state[0] & j) | (state[1] & ~k);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state (one-hot)
    end else begin
        state <= {next_ON, next_OFF};
    end
end

// Output is simply the ON state bit
assign out = state[1];

endmodule