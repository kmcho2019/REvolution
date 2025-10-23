`timescale 1ns/1ps

module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} current_state, next_state;

// State transition logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= (in) ? B : A;
            B: current_state <= (in) ? B : C;
            C: current_state <= (in) ? D : A;
            D: current_state <= (in) ? B : C;
            default: current_state <= A; // Default state
        endcase
    end
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output
    endcase
end

endmodule