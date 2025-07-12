`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state, next_state;

initial state = 4'b0001;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        4'b0001: next_state = in ? 4'b0010 : 4'b0001;
        4'b0010: next_state = in ? 4'b0010 : 4'b0100;
        4'b0100: next_state = in ? 4'b1000 : 4'b0001;
        4'b1000: next_state = in ? 4'b0010 : 4'b0100;
        default: next_state = 4'b0001;
    endcase
end

always @(*) begin
    case (state)
        4'b0001: out = 0;
        4'b0010: out = 0;
        4'b0100: out = 0;
        4'b1000: out = 1;
        default: out = 0;
    endcase
end

endmodule