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

always_comb begin
    case (currentState)
        3'b000: nextState = x ? nextStateTable[0][1] : nextStateTable[0][0];
        3'b001: nextState = x ? nextStateTable[1][1] : nextStateTable[1][0];
        3'b010: nextState = x ? nextStateTable[2][1] : nextStateTable[2][0];
        3'b011: nextState = x ? nextStateTable[3][1] : nextStateTable[3][0];
        3'b100: nextState = x ? nextStateTable[4][1] : nextStateTable[4][0];
        default: nextState = 3'b000;
    endcase
end

assign Y0 = nextState[0];
assign z = zTable[currentState];

initial begin
    currentState = 3'b000;
end