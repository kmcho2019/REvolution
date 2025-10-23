`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state;
reg [3:0] next_state;

// Initialize the state to A
initial state = 4'b0001;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        4'b0001: next_state = in ? 4'b0010 : 4'b0001;
        4'b0010: next_state = in ? 4'b0010 : 4'b0100;
        4'b0100: next_state = in ? 4'b1000 : 4'b0001;
        4'b1000: next_state = in ? 4'b0010 : 4'b0100;
        default: next_state = 4'b0001;
    endcase
end

// Output logic
assign out = (state == 4'b1000);

endmodule