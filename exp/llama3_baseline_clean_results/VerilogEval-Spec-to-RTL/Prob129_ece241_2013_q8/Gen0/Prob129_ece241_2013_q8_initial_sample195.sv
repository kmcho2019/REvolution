module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states of the FSM
typedef enum logic [1:0] {S0, S1, S2} state_t;

// Declare the current and next state
state_t current_state, next_state;

// Define the output z based on the current state and input x
always_comb begin
    case (current_state)
        S0: z = 1'b0;
        S1: z = (x == 1'b0) ? 1'b0 : 1'b0;
        S2: z = (x == 1'b1) ? 1'b1 : 1'b0;
        default: z = 1'b0;
    endcase
end

// Define the state transitions
always_comb begin
    case (current_state)
        S0: begin
            if (x == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (x == 1'b0) next_state = S2;
            else if (x == 1'b1) next_state = S1;
            else next_state = S1;
        end
        S2: begin
            if (x == 1'b1) next_state = S1;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Update the current state
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule