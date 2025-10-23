module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// LUT for next state transitions
reg [1:0] state_lut [0:3][0:1]; // [current_state][train_taken]

// Initialize LUT
initial begin
    // current_state = 0
    state_lut[0][0] = 2'b00; // no change
    state_lut[0][1] = 2'b01; // increment
    // current_state = 1
    state_lut[1][0] = 2'b00; // decrement
    state_lut[1][1] = 2'b10; // increment
    // current_state = 2
    state_lut[2][0] = 2'b01; // decrement
    state_lut[2][1] = 2'b11; // increment
    // current_state = 3
    state_lut[3][0] = 2'b10; // decrement
    state_lut[3][1] = 2'b11; // no change
end

// Next state selection
wire [1:0] next_state = train_valid ? state_lut[state][train_taken] : state;

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule