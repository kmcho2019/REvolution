`timescale 1ns/1ns

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as an enum
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Current state
state_t current_state;

// Next state
state_t next_state;

// Output
assign out = (current_state == D) ? 1'b1 : 1'b0;

// Combinational logic to determine next state
always_comb begin
    case (current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule