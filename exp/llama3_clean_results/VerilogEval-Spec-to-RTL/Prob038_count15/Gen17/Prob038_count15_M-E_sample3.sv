module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the states for the FSM
typedef enum logic [3:0] {
    S0 = 4'd0,
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7 = 4'd7,
    S8 = 4'd8,
    S9 = 4'd9,
    S10 = 4'd10,
    S11 = 4'd11,
    S12 = 4'd12,
    S13 = 4'd13,
    S14 = 4'd14,
    S15 = 4'd15
} state_t;

state_t current_state, next_state;

// FSM logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to initial state
        current_state <= S0;
    end else begin
        // Transition to next state
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S5;
        S5: next_state = S6;
        S6: next_state = S7;
        S7: next_state = S8;
        S8: next_state = S9;
        S9: next_state = S10;
        S10: next_state = S11;
        S11: next_state = S12;
        S12: next_state = S13;
        S13: next_state = S14;
        S14: next_state = S15;
        S15: next_state = S0; // Wrap around to S0
        default: next_state = S0; // Default to S0
    endcase
    
    // Handle reset condition
    if (reset) begin
        next_state = S0;
    end
end

// Output logic
assign q = current_state;

endmodule