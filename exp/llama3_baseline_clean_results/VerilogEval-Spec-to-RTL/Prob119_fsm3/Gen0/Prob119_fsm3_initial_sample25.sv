`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

// Current state and next state
state_type current_state, next_state;

// Output logic
always_comb begin
    case (current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule