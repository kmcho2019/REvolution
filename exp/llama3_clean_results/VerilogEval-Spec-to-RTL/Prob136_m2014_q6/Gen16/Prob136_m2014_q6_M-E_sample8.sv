module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] currentState;

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

// Output z logic
assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        case (currentState)
            A: currentState <= lut_next_state[0][w];
            B: currentState <= lut_next_state[1][w];
            C: currentState <= lut_next_state[2][w];
            D: currentState <= lut_next_state[3][w];
            E: currentState <= lut_next_state[4][w];
            F: currentState <= lut_next_state[5][w];
            default: currentState <= A;
        endcase
    end
end

endmodule