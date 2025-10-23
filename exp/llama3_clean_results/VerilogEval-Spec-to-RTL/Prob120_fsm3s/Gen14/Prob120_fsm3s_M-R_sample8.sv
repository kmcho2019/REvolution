`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

initial state = A;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

assign next_state = 
    (state == A && in == 1'b0) ? A :
    (state == A && in == 1'b1) ? B :
    (state == B && in == 1'b0) ? C :
    (state == B && in == 1'b1) ? B :
    (state == C && in == 1'b0) ? A :
    (state == C && in == 1'b1) ? D :
    (state == D && in == 1'b0) ? C :
    (state == D && in == 1'b1) ? B : 2'b00;

assign out = (state == D) ? 1'b1 : 1'b0;

endmodule