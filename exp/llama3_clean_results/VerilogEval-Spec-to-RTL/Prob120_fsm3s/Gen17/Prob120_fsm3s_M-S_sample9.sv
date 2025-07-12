`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: next_state = in? 2'b01 : 2'b00;
        2'b01: next_state = in? 2'b01 : 2'b10;
        2'b10: next_state = in? 2'b11 : 2'b00;
        2'b11: next_state = in? 2'b01 : 2'b10;
        default: next_state = 2'b00;
    endcase
end

always @(*) begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 0;
        2'b11: out = 1;
        default: out = 0;
    endcase
end

endmodule