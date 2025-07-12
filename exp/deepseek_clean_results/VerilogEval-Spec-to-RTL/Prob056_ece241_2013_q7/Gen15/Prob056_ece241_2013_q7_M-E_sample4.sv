module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

// State encoding:
// 00 - Q=0, last transition was reset
// 01 - Q=1, last transition was set
// 10 - Q=0, last transition was toggle
// 11 - Q=1, last transition was toggle
reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case ({j, k})
        2'b00: next_state = state;           // Hold state
        2'b01: next_state = 2'b00;           // Reset
        2'b10: next_state = 2'b01;           // Set
        2'b11: next_state = {~state[0], 1'b1}; // Toggle
    endcase
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output logic
assign Q = state[0];

endmodule