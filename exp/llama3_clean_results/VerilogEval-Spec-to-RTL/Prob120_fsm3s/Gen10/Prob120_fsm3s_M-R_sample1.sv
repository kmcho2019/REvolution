`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state;
reg [1:0] next_state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;
            2'b01: next_state = in ? 2'b01 : 2'b10;
            2'b10: next_state = in ? 2'b11 : 2'b00;
            2'b11: next_state = in ? 2'b01 : 2'b10;
        endcase
        state <= next_state;
    end
end

assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule