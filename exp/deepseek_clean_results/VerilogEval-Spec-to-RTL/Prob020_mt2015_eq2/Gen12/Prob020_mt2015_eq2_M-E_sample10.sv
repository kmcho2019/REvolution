module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Concatenate inputs to form 4-bit LUT address
    wire [3:0] lut_addr = {A, B};
    
    // LUT implementation for equality check
    // Outputs 1 only when A == B (4 cases)
    assign z = (lut_addr == 4'b0000) ||  // A=00, B=00
               (lut_addr == 4'b0101) ||  // A=01, B=01
               (lut_addr == 4'b1010) ||  // A=10, B=10
               (lut_addr == 4'b1111);    // A=11, B=11
    
    /* Implementation notes:
     * - In FPGA: Maps directly to one 4-input LUT
     * - In ASIC: Can be implemented as optimized ROM structure
     * - Equal delay for all input combinations
     * - Easily extendable to wider inputs
     */
endmodule