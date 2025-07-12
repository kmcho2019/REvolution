// Module TopModule implements a clocked 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.
// The inputs are registered, and the selection is made based on the registered values.

module TopModule(
    input             clk,  // clock signal
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input       sel,  // select line
    output [99:0] out // 100-bit output
);

// Internal registers to store inputs 'a' and 'b'
reg [99:0] reg_a;
reg [99:0] reg_b;

// Always block to register inputs on the rising edge of the clock
always @(posedge clk) begin
    reg_a <= a;  // Register input 'a'
    reg_b <= b;  // Register input 'b'
end

// Use a ternary operator to conditionally assign 'out' based on 'sel'
// This is an efficient way to implement a 2-1 multiplexer.
assign out = sel ? reg_b : reg_a;

endmodule