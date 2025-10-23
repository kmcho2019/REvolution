module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

logic [2:0] currentState, nextState;

// Define the lookup table for next state and output
logic [2:0] nextStateTable [5][2] = {
    {3'b000, 3'b001},  // Current state 000
    {3'b001, 3'b100},  // Current state 001
    {3'b010, 3'b001},  // Current state 010
    {3'b001, 3'b010},  // Current state 011
    {3'b011, 3'b100}   // Current state 100
};

logic zTable [5] = {
    1'b0,  // Current state 000
    1'b0,  // Current state 001
    1'b0,  // Current state 010
    1'b1,  // Current state 011
    1'b1   // Current state 100
};

always_ff @(posedge clk) begin
    currentState <= nextState;
end

// Use a simpler approach to assign nextState
assign nextState = nextStateTable[y][x];

// Directly drive z from zTable based on currentState
assign z = zTable[y];

assign Y0 = nextState[0];

// Default initial state can be defined here if needed, but typically an asynchronous reset is used
// initial begin
//     currentState = 3'b000;
// end