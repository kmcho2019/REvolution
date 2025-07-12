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
reg [1:0] next_state;

initial state = STATE_A;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

assign next_state = (state == STATE_A) ? (in ? STATE_B : STATE_A) :
                    (state == STATE_B) ? (in ? STATE_B : STATE_C) :
                    (state == STATE_C) ? (in ? STATE_D : STATE_A) :
                    (state == STATE_D) ? (in ? STATE_B : STATE_C) : STATE_A;

assign out = (state == STATE_D) ? 1'b1 : 1'b0;

endmodule