module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Directly assign the replicated sign bits and the input to out
    assign out = {24{in[7]}, in};
    
    // This approach maintains the simplicity and efficiency of the original design
    // and potentially improves timing by reducing the number of operations.
endmodule