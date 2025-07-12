module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Define a local variable to hold the replicated sign bits
    wire [23:0] sign_bits;
    
    // Use the replication operator to fill sign_bits with the sign bit of in
    assign sign_bits = {24{in[7]}};
    
    // Concatenate the replicated sign bits with the input
    assign out = {sign_bits, in};
    
    // This structure maintains the simplicity and efficiency of the original design
    // but utilizes a local variable for improved readability and maintainability.
endmodule