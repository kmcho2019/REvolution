module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Directly assign the replicated sign bits and the input to the output
    assign out = {24{in[7]}, in};
    
    // This simplified structure maintains the original design's efficiency and functionality
    // while reducing complexity by eliminating the intermediate variable.
endmodule