module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding: [1] = ON, [0] = OFF
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state
    end
    else begin
        // Parallel state transition logic:
        // OFF -> ON when j=1, otherwise stay OFF
        // ON -> OFF when k=1, otherwise stay ON
        state[1] <= (state[0] & j) | (state[1] & ~k);
        state[0] <= (state[1] & k) | (state[0] & ~j);
    end
end

// Output is simply the ON state bit
assign out = state[1];

endmodule