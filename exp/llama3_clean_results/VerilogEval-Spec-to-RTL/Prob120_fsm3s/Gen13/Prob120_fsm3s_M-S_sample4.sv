`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
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

// Determine the output directly based on the state
always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        out <= (state == D)? 1'b1 : 1'b0;
    end
end

endmodule