module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Next state LUT [state][in] -> next_state
reg [1:0] next_state_lut [0:3][0:1];
initial begin
    // State A transitions
    next_state_lut[2'b00][1'b0] = 2'b00; // A->A when in=0
    next_state_lut[2'b00][1'b1] = 2'b01; // A->B when in=1
    
    // State B transitions
    next_state_lut[2'b01][1'b0] = 2'b10; // B->C when in=0
    next_state_lut[2'b01][1'b1] = 2'b01; // B->B when in=1
    
    // State C transitions
    next_state_lut[2'b10][1'b0] = 2'b00; // C->A when in=0
    next_state_lut[2'b10][1'b1] = 2'b11; // C->D when in=1
    
    // State D transitions
    next_state_lut[2'b11][1'b0] = 2'b10; // D->C when in=0
    next_state_lut[2'b11][1'b1] = 2'b01; // D->B when in=1
end

// Output LUT [state] -> out
reg output_lut [0:3];
initial begin
    output_lut[2'b00] = 1'b0; // State A
    output_lut[2'b01] = 1'b0; // State B
    output_lut[2'b10] = 1'b0; // State C
    output_lut[2'b11] = 1'b1; // State D
end

always @(*) begin
    next_state = next_state_lut[state][in];
    out = output_lut[state];
end

endmodule