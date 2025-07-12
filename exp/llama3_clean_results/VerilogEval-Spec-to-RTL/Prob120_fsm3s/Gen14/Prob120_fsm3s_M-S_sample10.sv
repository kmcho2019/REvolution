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

// Update the state and determine the output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: if (in) begin state <= B; out <= 0; end else begin state <= A; out <= 0; end
            B: if (in) begin state <= B; out <= 0; end else begin state <= C; out <= 0; end
            C: if (in) begin state <= D; out <= 0; end else begin state <= A; out <= 0; end
            D: if (in) begin state <= B; out <= 1; end else begin state <= C; out <= 1; end
            default: begin state <= A; out <= 0; end
        endcase
    end
end

endmodule