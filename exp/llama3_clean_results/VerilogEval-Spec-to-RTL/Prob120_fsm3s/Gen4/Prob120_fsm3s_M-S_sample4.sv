`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

enum logic [1:0] {A, B, C, D} state, next_state;

always @(posedge clk) begin
    if (reset) state <= A;
    else begin
        case (state)
            A: begin state <= in ? B : A; out <= 0; end
            B: begin state <= in ? B : C; out <= 0; end
            C: begin state <= in ? D : A; out <= 0; end
            D: begin state <= in ? B : C; out <= 1; end
        endcase
    end
end

endmodule