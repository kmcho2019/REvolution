module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Assign the output based on the current state
always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'bx; // Invalid state, assign unknown value
    endcase
end

// Define the state transitions
always_comb begin
    case (state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF; // Invalid state, transition to OFF
    endcase
end

// Update the state on the rising edge of the clock
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= OFF; // Synchronous reset to state OFF
    end else begin
        state <= next_state;
    end
end

endmodule