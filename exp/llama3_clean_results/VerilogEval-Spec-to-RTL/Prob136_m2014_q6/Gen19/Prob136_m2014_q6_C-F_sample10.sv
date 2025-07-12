module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using a hybrid encoding scheme
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b011;
parameter D = 3'b100;
parameter E = 3'b101;
parameter F = 3'b110;

// State register
reg [2:0] currentState;
reg [2:0] nextState;

// Lookup table for next states
reg [2:0] lut_next_state [6][2];

// Initialize the lookup table
initial begin
    // A
    lut_next_state[0][0] = B; // w = 0
    lut_next_state[0][1] = A; // w = 1
    
    // B
    lut_next_state[1][0] = C; // w = 0
    lut_next_state[1][1] = D; // w = 1
    
    // C
    lut_next_state[2][0] = E; // w = 0
    lut_next_state[2][1] = D; // w = 1
    
    // D
    lut_next_state[3][0] = F; // w = 0
    lut_next_state[3][1] = A; // w = 1
    
    // E
    lut_next_state[4][0] = E; // w = 0
    lut_next_state[4][1] = D; // w = 1
    
    // F
    lut_next_state[5][0] = C; // w = 0
    lut_next_state[5][1] = D; // w = 1
end

// Combinational logic to determine the next state using the LUT
always @(*) begin
    case (currentState)
        A: nextState = lut_next_state[0][w];
        B: nextState = lut_next_state[1][w];
        C: nextState = lut_next_state[2][w];
        D: nextState = lut_next_state[3][w];
        E: nextState = lut_next_state[4][w];
        F: nextState = lut_next_state[5][w];
        default: nextState = A;
    endcase
end

// Output z logic
assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule