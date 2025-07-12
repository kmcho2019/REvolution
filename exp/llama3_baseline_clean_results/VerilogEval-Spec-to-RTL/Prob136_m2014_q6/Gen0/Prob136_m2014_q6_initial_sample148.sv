`timescale 1ns/1ns

module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states as enumerated values
typedef enum {A, B, C, D, E, F} state_type;
state_type current_state, next_state;

// Output z is 1 in states E and F, 0 otherwise
always @(*)
begin
    case (current_state)
        E, F: z = 1;
        default: z = 0;
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*)
begin
    case (current_state)
        A: if (w) next_state = A; else next_state = B;
        B: if (w) next_state = D; else next_state = C;
        C: if (w) next_state = D; else next_state = E;
        D: if (w) next_state = A; else next_state = F;
        E: if (w) next_state = D; else next_state = E;
        F: if (w) next_state = D; else next_state = C;
        default: next_state = A; // default to state A for invalid states
    endcase
end

endmodule