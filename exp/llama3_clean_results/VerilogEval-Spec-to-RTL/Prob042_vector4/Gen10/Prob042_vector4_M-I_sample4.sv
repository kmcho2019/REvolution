module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Directly assign the replicated sign bits and the input to the output
    // This approach maintains the simplicity and efficiency of the original design
    // and might be optimized further by synthesis tools.
    assign out = {24{in[7]}, in};
endmodule