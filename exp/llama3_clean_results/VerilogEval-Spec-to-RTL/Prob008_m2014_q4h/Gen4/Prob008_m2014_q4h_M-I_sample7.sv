module TopModule(
    input  in,
    output out
);
// The assign statement is used to directly connect the input to the output.
// This approach is already optimized for area and performance, given the simplicity of the module.
assign out = in;
endmodule