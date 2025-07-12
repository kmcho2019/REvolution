`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A; // Default to A for any other state
        endcase
    end
end

// Output logic using assign
assign out = (state == D);

endmodule