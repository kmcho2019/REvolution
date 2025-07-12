`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;
localparam STATE_D = 2'b11;

reg [1:0] state;
reg [1:0] nextState;

initial state = STATE_A;

always @(*) begin
    case (state)
        STATE_A: nextState = in? STATE_B : STATE_A;
        STATE_B: nextState = in? STATE_B : STATE_C;
        STATE_C: nextState = in? STATE_D : STATE_A;
        STATE_D: nextState = in? STATE_B : STATE_C;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        state <= nextState;
    end
end

assign out = (state == STATE_D);

endmodule