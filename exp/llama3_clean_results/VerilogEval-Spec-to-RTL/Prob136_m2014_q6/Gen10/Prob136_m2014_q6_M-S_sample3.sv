module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

// Look-Up Table (LUT) for next state
reg [2:0] lut_next_state [8];

always @(*) begin
    // Initialize LUT with next state values
    lut_next_state[0] = B; // A, w=0
    lut_next_state[1] = A; // A, w=1
    lut_next_state[2] = C; // B, w=0
    lut_next_state[3] = D; // B, w=1
    lut_next_state[4] = E; // C, w=0
    lut_next_state[5] = D; // C, w=1
    lut_next_state[6] = F; // D, w=0
    lut_next_state[7] = A; // D, w=1

    // Determine next state based on current state and input
    next_state = lut_next_state[{state[1:0], w}];
end

// Output z logic
assign z = (state[2]);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule