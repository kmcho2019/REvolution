module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the LUT for next state
reg [2:0] next_state_lut [8][2] = {
    {3'b000, 3'b001}, // y = 000, x = 0 or 1
    {3'b001, 3'b100}, // y = 001, x = 0 or 1
    {3'b010, 3'b001}, // y = 010, x = 0 or 1
    {3'b001, 3'b010}, // y = 011, x = 0 or 1
    {3'b011, 3'b100}, // y = 100, x = 0 or 1
    {3'b000, 3'b000}, // y = 101, x = 0 or 1 (not specified, default to 000)
    {3'b000, 3'b000}, // y = 110, x = 0 or 1 (not specified, default to 000)
    {3'b000, 3'b000}  // y = 111, x = 0 or 1 (not specified, default to 000)
};

// Define the LUT for output z
reg output_lut [8] = {
    1'b0, // y = 000
    1'b0, // y = 001
    1'b0, // y = 010
    1'b1, // y = 011
    1'b1, // y = 100
    1'b0, // y = 101 (not specified, default to 0)
    1'b0, // y = 110 (not specified, default to 0)
    1'b0   // y = 111 (not specified, default to 0)
};

// Combinational logic for next state
always @ (*) begin
    next_state = next_state_lut[y][x];
end

// Output logic
always @ (*) begin
    z = output_lut[y];
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];

endmodule