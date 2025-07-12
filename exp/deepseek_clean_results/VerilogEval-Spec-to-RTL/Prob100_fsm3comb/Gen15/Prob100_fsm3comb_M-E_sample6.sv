module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Combined next_state and output LUT
// Format: {out, next_state[1:0]}
reg [2:0] transition_lut [0:7];

// Initialize LUT
integer i;
initial begin
    // Index format: {state[1:0], in}
    transition_lut[3'b000] = {1'b0, 2'b00}; // A, in=0 → A
    transition_lut[3'b001] = {1'b0, 2'b01}; // A, in=1 → B
    transition_lut[3'b010] = {1'b0, 2'b10}; // B, in=0 → C
    transition_lut[3'b011] = {1'b0, 2'b01}; // B, in=1 → B
    transition_lut[3'b100] = {1'b0, 2'b00}; // C, in=0 → A
    transition_lut[3'b101] = {1'b0, 2'b11}; // C, in=1 → D
    transition_lut[3'b110] = {1'b1, 2'b10}; // D, in=0 → C
    transition_lut[3'b111] = {1'b1, 2'b01}; // D, in=1 → B
end

// Lookup operation
wire [2:0] lut_output = transition_lut[{state, in}];

assign out = lut_output[2];
assign next_state = lut_output[1:0];

endmodule