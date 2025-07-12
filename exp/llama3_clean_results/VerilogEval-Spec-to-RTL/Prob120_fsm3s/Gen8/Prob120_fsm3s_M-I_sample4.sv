`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// State encoding: A=00, B=01, C=10, D=11
reg [1:0] state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : 2'b00; // A to B or stay in A
            2'b01: state <= in? 2'b01 : 2'b10; // B to C or stay in B
            2'b10: state <= in? 2'b11 : 2'b00; // C to D or back to A
            2'b11: state <= in? 2'b01 : 2'b10; // D to B or back to C
        endcase
    end
end

// Output logic based on the state
assign out = (state == 2'b11); // Output is 1 only when in state D

endmodule