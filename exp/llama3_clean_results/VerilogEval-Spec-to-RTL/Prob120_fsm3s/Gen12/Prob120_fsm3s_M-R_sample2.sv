`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

// Determine the next state using combinational logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine the output, simplified based on observation
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule