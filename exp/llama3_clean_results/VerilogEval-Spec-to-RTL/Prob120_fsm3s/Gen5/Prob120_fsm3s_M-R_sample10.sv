`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
reg [1:0] state;
reg [1:0] next_state;

// Initialize the state to A (00)
initial state = 2'b00;

// Define the next state logic
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A
        2'b01: next_state = in ? 2'b01 : 2'b10; // B
        2'b10: next_state = in ? 2'b11 : 2'b00; // C
        2'b11: next_state = in ? 2'b01 : 2'b10; // D
        default: next_state = 2'b00;
    endcase
end

// Define the output logic
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule