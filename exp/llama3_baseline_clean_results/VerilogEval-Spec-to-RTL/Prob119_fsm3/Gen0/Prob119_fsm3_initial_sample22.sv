`timescale 1ns/1ps

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Enumerating states
enum logic [1:0] {A, B, C, D} state, next_state;

// Combinational logic
always_comb begin
    case(state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
always_comb begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule