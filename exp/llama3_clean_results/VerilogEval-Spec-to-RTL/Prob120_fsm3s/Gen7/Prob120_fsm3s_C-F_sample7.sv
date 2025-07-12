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

// Update the state on the positive edge of the clock and determine the output
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: begin
                state <= in ? B : A;
                out <= 0;
            end
            B: begin
                state <= in ? B : C;
                out <= 0;
            end
            C: begin
                state <= in ? D : A;
                out <= 0;
            end
            D: begin
                state <= in ? B : C;
                out <= 1;
            end
        endcase
    end
end

endmodule