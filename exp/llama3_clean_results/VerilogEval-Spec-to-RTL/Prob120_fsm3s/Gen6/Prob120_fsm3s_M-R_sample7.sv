`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : state;
            2'b01: state <= in? state : 2'b10;
            2'b10: state <= in? 2'b11 : 2'b00;
            2'b11: state <= in? 2'b01 : state;
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0;
        2'b11: out = 1'b1;
    endcase
end

endmodule