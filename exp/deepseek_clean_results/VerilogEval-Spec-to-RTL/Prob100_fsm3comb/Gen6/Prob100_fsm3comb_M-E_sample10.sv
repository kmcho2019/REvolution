module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// LUT for next state transitions [current_state][input]
reg [1:0] state_lut [0:3][0:1];

initial begin
    // State A transitions
    state_lut[2'b00][0] = 2'b00; // A -> A when in=0
    state_lut[2'b00][1] = 2'b01; // A -> B when in=1
    
    // State B transitions
    state_lut[2'b01][0] = 2'b10; // B -> C when in=0
    state_lut[2'b01][1] = 2'b01; // B -> B when in=1
    
    // State C transitions
    state_lut[2'b10][0] = 2'b00; // C -> A when in=0
    state_lut[2'b10][1] = 2'b11; // C -> D when in=1
    
    // State D transitions
    state_lut[2'b11][0] = 2'b10; // D -> C when in=0
    state_lut[2'b11][1] = 2'b01; // D -> B when in=1
end

always @(*) begin
    next_state = state_lut[state][in];
    out = (state == 2'b11); // Output 1 only in state D
end

endmodule