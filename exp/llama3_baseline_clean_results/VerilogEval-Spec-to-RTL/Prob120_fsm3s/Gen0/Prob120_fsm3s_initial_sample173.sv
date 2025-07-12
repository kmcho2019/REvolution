`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

state_t current_state, next_state;

always @(*) begin
    case(current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        out <= 0;
    end else begin
        current_state <= next_state;
        case(current_state)
            A, B, C: out <= 0;
            D: out <= 1;
            default: out <= 0;
        endcase
    end
end

initial begin
    current_state = A;
end

endmodule