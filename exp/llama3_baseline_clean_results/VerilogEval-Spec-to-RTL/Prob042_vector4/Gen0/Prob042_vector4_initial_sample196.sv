module TopModule(
    input [7:0] in,  // input 8-bit number
    output [31:0] out  // output 32-bit sign-extended number
);
    
    // Sign extend the input number by replicating the sign bit (in[7]) 24 times
    assign out = { {24{in[7]}}, in };  // Concatenate 24 sign bits with the input number

endmodule