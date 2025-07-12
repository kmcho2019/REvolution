`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;
reg [3:0] state, next_state;

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

// Next state logic
always @(*) begin
    case (1'b1)
        state[0]: next_state = in ? B : A;
        state[1]: next_state = in ? B : C;
        state[2]: next_state = in ? D : A;
        state[3]: next_state = in ? B : C;
    endcase
end

// Output logic
assign out = state[3];

endmodule