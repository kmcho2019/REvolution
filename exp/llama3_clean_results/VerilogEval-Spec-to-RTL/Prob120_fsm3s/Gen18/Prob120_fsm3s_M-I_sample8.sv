`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

localparam STATE_A = 1'b1;
localparam STATE_B = 1'b10;
localparam STATE_C = 1'b100;
localparam STATE_D = 1'b1000;

reg [3:0] state;
reg [3:0] next_state;

initial state = STATE_A;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        STATE_A: next_state = (in) ? STATE_B : STATE_A;
        STATE_B: next_state = (in) ? STATE_B : STATE_C;
        STATE_C: next_state = (in) ? STATE_D : STATE_A;
        STATE_D: next_state = (in) ? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

assign out = (state == STATE_D);

endmodule