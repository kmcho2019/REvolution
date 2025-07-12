// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block to implement the multiplexer logic.
always @(*) begin
    // Use a conditional statement to select between 'a' and 'b' based on 'sel'.
    if (sel) begin
        // When 'sel' is 1, select 'b'.
        out = b;
    end else begin
        // When 'sel' is 0, select 'a'.
        out = a;
    end
end

// Alternatively, the following implementation using a for loop can also be used:
// always @(*) begin
//     for (int i = 0; i < 100; i++) begin
//         if (sel) begin
//             out[i] = b[i];
//         end else begin
//             out[i] = a[i];
//         end
//     end
// end

// To further optimize the design for Power, Performance, and Area (PPA) metrics, consider the following strategies:
// 1. Minimize the switching activity of the 100-bit inputs 'a' and 'b' to reduce power consumption.
// 2. Ensure the synthesis tool is properly optimizing the combinatorial logic for better performance.
// 3. Explore different architectural choices or use area-efficient standard cells during synthesis to reduce area.

endmodule