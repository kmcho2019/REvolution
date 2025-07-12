module TopModule(
    input  [31:0] input_vector,  // Input 32-bit vector
    output [31:0] output_vector   // Output 32-bit vector with reversed byte order
);

    // Reverse the byte order of the input vector
    assign output_vector = {input_vector[7:0], input_vector[15:8], input_vector[23:16], input_vector[31:24]};

endmodule