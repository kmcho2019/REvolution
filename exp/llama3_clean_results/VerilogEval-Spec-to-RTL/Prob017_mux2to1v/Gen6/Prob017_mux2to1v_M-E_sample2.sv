// Module TopModule implements a 2-1 multiplexer using AND-OR logic.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use AND-OR logic to conditionally assign 'out' based on 'sel'.
// For each bit position, create a pair of AND gates and an OR gate.
// The AND gates conditionally enable 'a' or 'b' based on 'sel'.
// The OR gate combines the enabled bits.
genvar i;
for (i = 0; i < 100; i++) begin
    // Create AND gates for 'a' and 'b' based on 'sel'.
    assign out[i] = (sel == 0) ? a[i] : b[i];
    // Alternatively, you can use AND-OR gates explicitly as follows:
    // wire a_enabled, b_enabled;
    // assign a_enabled = (~sel) & a[i];
    // assign b_enabled = sel & b[i];
    // assign out[i] = a_enabled | b_enabled;
end

endmodule