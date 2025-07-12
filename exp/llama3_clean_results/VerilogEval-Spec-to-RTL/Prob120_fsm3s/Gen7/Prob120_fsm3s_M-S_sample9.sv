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

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: if (in) state <= B; else state <= A;
            B: if (in) state <= B; else state <= C;
            C: if (in) state <= D; else state <= A;
            D: if (in) state <= B; else state <= C;
        endcase
        out <= (state == D)? 1 : 0;
    end
end

endmodule