module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Look-up table for next state
reg [2:0] next_state_lut [8][2] = {
    {3'b000, 3'b001},  // State 0, x=0, x=1
    {3'b001, 3'b100},  // State 1, x=0, x=1
    {3'b010, 3'b001},  // State 2, x=0, x=1
    {3'b001, 3'b010},  // State 3, x=0, x=1
    {3'b011, 3'b100},  // State 4, x=0, x=1
    {3'b100, 3'b100},  // State 5, x=0, x=1
    {3'b011, 3'b011},  // State 6, x=0, x=1
    {3'b100, 3'b100}   // State 7, x=0, x=1
};

// Look-up table for output z
reg [0:0] output_z_lut [8] = {
    1'b0,  // State 0
    1'b0,  // State 1
    1'b0,  // State 2
    1'b1,  // State 3
    1'b1,  // State 4
    1'b1,  // State 5
    1'b1,  // State 6
    1'b1   // State 7
};

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
    z <= output_z_lut[current_state];
end

// Combinational logic for next state
always @ (*) begin
    next_state = next_state_lut[y][x];
    Y0 = next_state[0];
end

// Initialize state
initial begin
    current_state = 3'b000;
end

endmodule