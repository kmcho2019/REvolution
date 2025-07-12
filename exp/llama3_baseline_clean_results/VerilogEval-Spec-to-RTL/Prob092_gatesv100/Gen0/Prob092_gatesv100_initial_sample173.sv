module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: Each bit is '1' if the corresponding input bit and its left neighbor are both '1'
// Perform a bitwise AND operation between the input vector and its left-shifted version
assign out_both = in & {1'b0, in[99:1]};

// out_any: Each bit is '1' if the corresponding input bit or its right neighbor is '1'
// Perform a bitwise OR operation between the input vector and its right-shifted version
assign out_any = in | {in[0], in[99:1]};

// out_different: Each bit is '1' if the corresponding input bit is different from its left neighbor
// Perform a bitwise XOR operation between the input vector and its left-shifted version (wrapping around)
assign out_different = in ^ {in[0], in[99:1]};

endmodule