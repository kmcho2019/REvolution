module TopModule(
    input  [99:0] in,
    output [99:0] out
);

assign out = {<< {99 {in}}}; // using a shift operator to reverse the bits

// Alternatively, without using the shift operator, we can use the following code:
// assign out = in[99:0]; // does not reverse the bits
// Instead, use a bit-range to reverse the bits:
// assign out = in[99-:100]; // using a slice to reverse the bits

// Or, using a for loop (though this is less efficient for this task):
// always @(in) begin
//     for (int i = 0; i < 100; i++) begin
//         out[99-i] = in[i];
//     end
// end

endmodule