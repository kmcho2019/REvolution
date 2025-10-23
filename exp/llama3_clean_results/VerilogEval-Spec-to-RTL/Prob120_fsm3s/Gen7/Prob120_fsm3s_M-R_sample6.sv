`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;

initial state = A;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
        endcase
    end
end

always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule