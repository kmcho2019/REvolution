// Module TopModule implements an XNOR gate using a combinational always block
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Intermediate signal for XOR result
wire xor_result;

// Combinational always block for XNOR implementation
always @(*) begin
    // Perform XOR operation
    xor_result = a ^ b;
    
    // Invert the XOR result to get XNOR
    out = ~xor_result;
end

endmodule