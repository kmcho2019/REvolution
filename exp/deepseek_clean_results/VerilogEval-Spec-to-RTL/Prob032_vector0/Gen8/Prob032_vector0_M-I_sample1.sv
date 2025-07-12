module TopModule (
    input [2:0] vec,          // 3-bit input vector (2: MSB, 0: LSB)
    output [2:0] outv,        // Mirror output of input vector
    output vec_bit2,          // MSB of input vector
    output vec_bit1,          // Middle bit of input vector
    output vec_bit0           // LSB of input vector
);

    // Direct vector assignment
    assign outv = vec;
    
    // Individual bit assignments with descriptive names
    assign vec_bit2 = vec[2];  // MSB
    assign vec_bit1 = vec[1];  // Middle bit
    assign vec_bit0 = vec[0];  // LSB

endmodule