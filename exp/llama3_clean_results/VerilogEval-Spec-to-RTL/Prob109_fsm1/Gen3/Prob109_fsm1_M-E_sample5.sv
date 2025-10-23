module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [1:0] state; // 2'b01 represents state B, 2'b00 represents state A
reg [1:0] next_state;

// LUT for next state and output
always @(*)
begin
    case({state, in})
        3'b001: next_state = 2'b01; // A, in=0 -> B
        3'b011: next_state = 2'b00; // A, in=1 -> A
        3'b101: next_state = 2'b00; // B, in=0 -> A
        3'b111: next_state = 2'b01; // B, in=1 -> B
        default: next_state = 2'b01; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 2'b01; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state[0];

endmodule