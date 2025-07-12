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
        out <= 1'b0;
    end else begin
        case (state)
            2'b00: if (~in) state <= 2'b00; else state <= 2'b01;
            2'b01: if (~in) state <= 2'b10; else state <= 2'b01;
            2'b10: if (~in) state <= 2'b00; else state <= 2'b11;
            2'b11: if (~in) state <= 2'b10; else state <= 2'b01;
        endcase
        out <= (state == 2'b11) ? 1'b1 : 1'b0;
    end
end

endmodule