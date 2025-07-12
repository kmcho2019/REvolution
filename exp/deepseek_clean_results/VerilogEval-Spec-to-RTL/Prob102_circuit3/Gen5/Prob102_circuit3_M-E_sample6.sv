module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Create a 4-bit input vector
    wire [3:0] inputs = {a, b, c, d};

    // Implement as a lookup table matching the truth table
    assign q = (inputs == 4'b0101) ||  // Case 40ns
               (inputs == 4'b0110) ||  // Case 45ns
               (inputs == 4'b0111) ||  // Case 50ns
               (inputs == 4'b1001) ||  // Case 60ns
               (inputs == 4'b1010) ||  // Case 65ns
               (inputs == 4'b1011) ||  // Case 70ns
               (inputs == 4'b1101) ||  // Case 80ns
               (inputs == 4'b1110) ||  // Case 85ns
               (inputs == 4'b1111);    // Case 90ns
endmodule