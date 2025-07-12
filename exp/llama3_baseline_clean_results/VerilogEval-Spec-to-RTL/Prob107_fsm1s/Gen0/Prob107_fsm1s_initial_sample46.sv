// Define the states as an enum
typedef enum logic {B, A} state_t;

module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Declare the current and next state variables
state_t current_state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (current_state)
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B; // Default to state B
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Output logic based on the current state
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default to out = 1
    endcase
end

endmodule