`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
enum logic [3:0] {A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000} state, next_state;

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

// Determine the output using a lookup table
always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule