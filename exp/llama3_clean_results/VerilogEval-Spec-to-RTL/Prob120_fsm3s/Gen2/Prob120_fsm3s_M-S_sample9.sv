`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state, next_state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin next_state = in ? 2'b01 : 2'b00; out = 0; end
        2'b01: begin next_state = in ? 2'b01 : 2'b10; out = 0; end
        2'b10: begin next_state = in ? 2'b11 : 2'b00; out = 0; end
        2'b11: begin next_state = in ? 2'b01 : 2'b10; out = 1; end
    endcase
end

endmodule