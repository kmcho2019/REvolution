module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding: OFF = 01, ON = 10
reg [1:0] state;

// Next state logic
wire next_state_OFF = (~state[1] & ~j) | (state[1] & k);
wire next_state_ON  = (~state[1] & j) | (state[1] & ~k);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state (01)
    end else begin
        state[0] <= next_state_OFF;
        state[1] <= next_state_ON;
    end
end

// Output logic - ON state is represented by state[1]
assign out = state[1];

endmodule