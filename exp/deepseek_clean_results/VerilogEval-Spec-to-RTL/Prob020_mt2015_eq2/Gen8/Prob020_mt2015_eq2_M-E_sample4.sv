module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // MUX-based equality checker
    // Uses concatenated AB as selector to choose between 1 (equal) or 0 (not equal)
    wire [3:0] selector = {A, B};
    
    assign z = (selector == 4'b0000) ? 1'b1 :  // A=00, B=00
               (selector == 4'b0101) ? 1'b1 :  // A=01, B=01
               (selector == 4'b1010) ? 1'b1 :  // A=10, B=10
               (selector == 4'b1111) ? 1'b1 :  // A=11, B=11
               1'b0;
endmodule