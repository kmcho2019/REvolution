`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using parameter definitions
parameter A = 0, B = 1, C = 2, D = 3;
reg [1:0] state, next_state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always @(*) begin
    case (state)
        A: begin
            next_state = in ? B : A;
            out = 0;
        end
        B: begin
            next_state = in ? B : C;
            out = 0;
        end
        C: begin
            next_state = in ? D : A;
            out = 0;
        end
        D: begin
            next_state = in ? B : C;
            out = 1;
        end
    endcase
end

endmodule