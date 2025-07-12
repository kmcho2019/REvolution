module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding (though only two states)
reg [1:0] state;  // state[0] = OFF, state[1] = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state
    end else begin
        // Compute next state using bitwise operations
        state[0] <= (state[0] & ~j) | (state[1] & k);
        state[1] <= (state[0] & j) | (state[1] & ~k);
    end
end

assign out = state[1];  // Output is ON state bit

endmodule