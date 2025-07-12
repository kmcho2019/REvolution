module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110,
    IDLE = 3'b000 // For unused states
} state_type;

// Current and next state variables
state_type current_state, next_state;

// Sequential logic for state transitions
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A; // Reset state
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output generation
always @(*) begin
    case(current_state)
        A: if(!w) next_state = B; else next_state = A;
        B: if(!w) next_state = C; else next_state = D;
        C: if(!w) next_state = E; else next_state = D;
        D: if(!w) next_state = F; else next_state = A;
        E: if(w) next_state = E; else next_state = D;
        F: if(w) next_state = F; else next_state = C;
        default: next_state = IDLE; // Default for unused states
    endcase
    
    // Generate output 'z' based on the state
    case(current_state)
        E, F: z = 1'b1; // Output is 1 for states E and F
        default: z = 1'b0; // Output is 0 for other states
    endcase
end

endmodule