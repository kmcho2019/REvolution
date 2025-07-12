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
reg clock_enable;

initial state = STATE_A;
initial clock_enable = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
        clock_enable <= 1'b1;
    end else if (clock_enable) begin
        case (state)
            STATE_A: state <= in? STATE_B : STATE_A;
            STATE_B: state <= in? STATE_B : STATE_C;
            STATE_C: state <= in? STATE_D : STATE_A;
            STATE_D: state <= in? STATE_B : STATE_C;
        endcase
    end
end

assign out = (state == STATE_D);

// Implement clock gating to reduce power consumption
always @(posedge clk) begin
    if (reset) begin
        clock_enable <= 1'b1;
    end else if (state == STATE_A &&!in) begin
        // If the FSM is in state A and input is 0, it will stay in state A
        clock_enable <= 1'b0;
    end else begin
        clock_enable <= 1'b1;
    end
end

endmodule