module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// LUT format: {next_state, output}
// Index format: {state, in}
reg [2:0] transition_lut [0:7];

initial begin
    // State A cases
    transition_lut[2'b00_0] = {2'b00, 1'b0}; // A,0 -> A,0
    transition_lut[2'b00_1] = {2'b01, 1'b0}; // A,1 -> B,0
    // State B cases
    transition_lut[2'b01_0] = {2'b10, 1'b0}; // B,0 -> C,0
    transition_lut[2'b01_1] = {2'b01, 1'b0}; // B,1 -> B,0
    // State C cases
    transition_lut[2'b10_0] = {2'b00, 1'b0}; // C,0 -> A,0
    transition_lut[2'b10_1] = {2'b11, 1'b0}; // C,1 -> D,0
    // State D cases
    transition_lut[2'b11_0] = {2'b10, 1'b1}; // D,0 -> C,1
    transition_lut[2'b11_1] = {2'b01, 1'b1}; // D,1 -> B,1
end

always @(*) begin
    {next_state, out} = transition_lut[{state, in}];
    // Override output based on current state (Moore property)
    out = (state == 2'b11) ? 1'b1 : 1'b0;
end

endmodule