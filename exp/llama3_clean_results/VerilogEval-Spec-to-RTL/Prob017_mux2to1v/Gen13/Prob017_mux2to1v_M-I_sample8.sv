// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Using an always block for combinational logic, which might offer better optimization opportunities compared to a continuous assignment for certain synthesis tools.
always @(*) begin
    // The ternary operator is used for simplicity and readability, allowing the synthesis tool to optimize the logic.
    out = sel ? b : a;
end

endmodule