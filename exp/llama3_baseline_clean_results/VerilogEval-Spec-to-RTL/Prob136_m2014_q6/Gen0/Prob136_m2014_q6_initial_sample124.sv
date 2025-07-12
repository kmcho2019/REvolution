`timescale 1ns/1ps

module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic w,
    output logic z
);

enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

always_comb begin
    case (state)
        A, B, C, D: z = 0;
        E, F: z = 1;
    endcase
end

endmodule