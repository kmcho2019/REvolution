module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Next State Lookup Table
reg [2:0] next_state_lut [8];
initial begin
    next_state_lut[0] = (x == 1'b0) ? 3'b000 : 3'b001; // For state 000
    next_state_lut[1] = (x == 1'b0) ? 3'b001 : 3'b100; // For state 001
    next_state_lut[2] = (x == 1'b0) ? 3'b010 : 3'b001; // For state 010
    next_state_lut[3] = (x == 1'b0) ? 3'b001 : 3'b010; // For state 011
    next_state_lut[4] = (x == 1'b0) ? 3'b011 : 3'b100; // For state 100
    next_state_lut[5] = (x == 1'b0) ? 3'b000 : 3'b000; // For state 101, not defined, default to 000
    next_state_lut[6] = (x == 1'b0) ? 3'b000 : 3'b000; // For state 110, not defined, default to 000
    next_state_lut[7] = (x == 1'b0) ? 3'b000 : 3'b000; // For state 111, not defined, default to 000
end

// Output Lookup Table
reg [0:0] output_lut [8];
initial begin
    output_lut[0] = 1'b0; // For state 000
    output_lut[1] = 1'b0; // For state 001
    output_lut[2] = 1'b0; // For state 010
    output_lut[3] = 1'b1; // For state 011
    output_lut[4] = 1'b1; // For state 100
    output_lut[5] = 1'b0; // For state 101, not defined, default to 0
    output_lut[6] = 1'b0; // For state 110, not defined, default to 0
    output_lut[7] = 1'b0; // For state 111, not defined, default to 0
end

always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    case (y)
        3'b000: next_state = next_state_lut[0];
        3'b001: next_state = next_state_lut[1];
        3'b010: next_state = next_state_lut[2];
        3'b011: next_state = next_state_lut[3];
        3'b100: next_state = next_state_lut[4];
        default: next_state = 3'b000; // Default to state 000 for undefined states
    endcase
    z = output_lut[y];
end

assign Y0 = next_state[0];

endmodule