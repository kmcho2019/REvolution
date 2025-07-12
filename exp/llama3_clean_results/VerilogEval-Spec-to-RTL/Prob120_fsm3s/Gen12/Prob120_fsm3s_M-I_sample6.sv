`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

localparam STATE_A = 1'b1;
localparam STATE_B = 1'b2;
localparam STATE_C = 1'b4;
localparam STATE_D = 1'b8;

reg [2:0] state;

initial state = STATE_A;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        case (state)
            STATE_A: state <= in? STATE_B : STATE_A;
            STATE_B: state <= in? STATE_B : STATE_C;
            STATE_C: state <= in? STATE_D : STATE_A;
            STATE_D: state <= in? STATE_B : STATE_C;
            default: state <= STATE_A;
        endcase
    end
end

assign out = (state == STATE_D);

endmodule