`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
} state, next_state;

always_comb begin
    case (state)
        STATE_A: next_state = in ? STATE_B : STATE_A;
        STATE_B: next_state = in ? STATE_B : STATE_C;
        STATE_C: next_state = in ? STATE_D : STATE_A;
        STATE_D: next_state = in ? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
        out <= 0;
    end else begin
        state <= next_state;
        out <= (state == STATE_D) ? 1 : 0;
    end
end

endmodule