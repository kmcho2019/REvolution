module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states of the FSM
typedef enum {S0, S1, S2, S3, S4, S5, S6, S7} state_t;
state_t current_state, next_state;

// Initialize the current state
initial current_state = S4;

// Define the next state logic
always @(posedge clk) begin
    if (a) begin
        next_state = S4;
    end else begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S0;
            default: next_state = S0;
        endcase
    end
    current_state <= next_state;
end

// Define the output logic
always @(current_state) begin
    case (current_state)
        S0: q = 0;
        S1: q = 1;
        S2: q = 2;
        S3: q = 3;
        S4: q = 4;
        S5: q = 5;
        S6: q = 6;
        S7: q = 7;
        default: q = 0;
    endcase
end

endmodule