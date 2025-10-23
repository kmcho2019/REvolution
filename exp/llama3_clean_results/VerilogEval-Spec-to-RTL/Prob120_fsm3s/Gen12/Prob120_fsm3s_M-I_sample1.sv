`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

localparam STATE_A = 4'b0001;
localparam STATE_B = 4'b0010;
localparam STATE_C = 4'b0100;
localparam STATE_D = 4'b1000;

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

assign next_state = 
    (state == STATE_A) ? (in ? STATE_B : STATE_A) :
    (state == STATE_B) ? STATE_B :
    (state == STATE_C) ? (in ? STATE_D : STATE_A) :
    (state == STATE_D) ? (in ? STATE_B : STATE_C);

assign out = (state == STATE_D);

endmodule