`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;
reg [3:0] state;
reg [3:0] next_state;

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

// Next state logic using one-hot encoding
always @(state, in) begin
    case(state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Output logic
assign out = (state == D);

// Clock gating (optional, depends on synthesis tool support)
// reg clk_gated;
// always @(posedge clk) begin
//     if (reset) begin
//         clk_gated <= 0;
//     end else begin
//         clk_gated <= 1;
//     end
// end
// assign clk_gated = (state != A); // Example condition, adjust according to design

endmodule