`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end
end

// Determine the output based on the current state
always @(state) begin
    case (state)
        A, B, C: out <= 0;
        D: out <= 1;
    endcase
end

endmodule