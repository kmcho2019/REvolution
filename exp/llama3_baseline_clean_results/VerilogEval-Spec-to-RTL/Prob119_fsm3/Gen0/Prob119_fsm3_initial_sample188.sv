`timescale 1ns / 1ps

module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

state_t state, next_state;
assign out = (state == D) ? 1'b1 : 1'b0;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= (in) ? B : A;
            B: state <= (in) ? B : C;
            C: state <= (in) ? D : A;
            D: state <= (in) ? B : C;
            default: state <= A;
        endcase
    end
end

endmodule