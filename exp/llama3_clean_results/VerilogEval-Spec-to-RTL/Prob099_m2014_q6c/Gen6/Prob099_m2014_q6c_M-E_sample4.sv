module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

reg [5:0] next_state;

// Define the lookup table for next-state values
reg [5:0] lut [6:0][2:0];

initial begin
    // Initialize the lookup table based on the state machine transitions
    lut[0][0] = 6'b000010;  // State A, w=0
    lut[0][1] = 6'b000001;  // State A, w=1
    lut[1][0] = 6'b000100;  // State B, w=0
    lut[1][1] = 6'b001000;  // State B, w=1
    lut[2][0] = 6'b100000;  // State C, w=0
    lut[2][1] = 6'b001000;  // State C, w=1
    lut[3][0] = 6'b100000;  // State D, w=0
    lut[3][1] = 6'b000001;  // State D, w=1
    lut[4][0] = 6'b100000;  // State E, w=0
    lut[4][1] = 6'b100000;  // State E, w=1
    lut[5][0] = 6'b001000;  // State F, w=0
    lut[5][1] = 6'b000100;  // State F, w=1
end

// Determine the index to the lookup table based on the current state
always @(y, w) begin
    // Identify the current state
    case (1'b1)
        y[0]: next_state = lut[0][w];  // State A
        y[1]: next_state = lut[1][w];  // State B
        y[2]: next_state = lut[2][w];  // State C
        y[3]: next_state = lut[3][w];  // State D
        y[4]: next_state = lut[4][w];  // State E
        y[5]: next_state = lut[5][w];  // State F
        default: next_state = 6'b000001;  // Default to State A
    endcase
end

// Derive the next-state signals Y1 and Y3
assign Y1 = next_state[1];  // y[1]
assign Y3 = next_state[3];  // y[3]

endmodule