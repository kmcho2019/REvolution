`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;
parameter STATE_A = 2'b00, STATE_B = 2'b01, STATE_C = 2'b10, STATE_D = 2'b11;

// Initialize the state to A
initial state = STATE_A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

// Next state logic using a case statement
always @(*) begin
    case (state)
        STATE_A: next_state = in ? STATE_B : STATE_A;
        STATE_B: next_state = in ? STATE_B : STATE_C;
        STATE_C: next_state = in ? STATE_D : STATE_A;
        STATE_D: next_state = in ? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

// Output logic using an assign statement
assign out = (state == STATE_D);

endmodule