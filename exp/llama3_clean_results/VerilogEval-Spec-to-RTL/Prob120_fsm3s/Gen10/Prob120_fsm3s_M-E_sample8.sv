`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] counter;
reg [1:0] next_counter;

initial counter = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
    end else begin
        counter <= next_counter;
    end
end

always @(*) begin
    case (counter)
        2'b00: next_counter = in? 2'b01 : 2'b00;
        2'b01: next_counter = in? 2'b01 : 2'b10;
        2'b10: next_counter = in? 2'b11 : 2'b00;
        2'b11: next_counter = in? 2'b01 : 2'b10;
    endcase
end

assign out = (counter == 2'b11);

endmodule