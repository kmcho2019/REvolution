`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Update state on positive edge of clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine next state based on current state and input
always @(*) begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A; // default to state A
    endcase
end

// Determine output z based on current state
always @(*) begin
    case (state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0; // default to 0
    endcase
end

endmodule