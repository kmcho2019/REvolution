// Module TopModule implements a 2-1 multiplexer using a for-loop for output generation.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a for-loop to generate the output bits based on the 'sel' input.
// For each bit, if 'sel' is 0, select the corresponding bit from 'a', otherwise select from 'b'.
genvar i;
for (i = 0; i < 100; i = i + 1) begin
    assign out[i] = (sel)? b[i] : a[i];
end

endmodule