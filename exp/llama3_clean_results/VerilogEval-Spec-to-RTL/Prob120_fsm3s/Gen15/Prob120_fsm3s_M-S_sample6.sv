`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a two-bit counter
reg [1:0] state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : 2'b00; // A
            2'b01: state <= in? 2'b01 : 2'b10; // B
            2'b10: state <= in? 2'b11 : 2'b00; // C
            2'b11: state <= in? 2'b01 : 2'b10; // D
            default: state <= 2'b00;
        endcase
    end
end

// Determine the output
always @(*) begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 0; // A, B, C
        2'b11: out = 1; // D
        default: out = 0;
    endcase
end

endmodule