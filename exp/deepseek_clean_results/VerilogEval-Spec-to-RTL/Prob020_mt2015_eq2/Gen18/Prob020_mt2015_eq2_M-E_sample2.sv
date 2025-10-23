module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Concatenate A and B to form select lines
    wire [3:0] sel = {A, B};
    
    // 16-to-1 mux that outputs 1 only when A == B
    assign z = (sel == 4'b0000) ? 1'b1 :  // A=00, B=00
               (sel == 4'b0101) ? 1'b1 :  // A=01, B=01
               (sel == 4'b1010) ? 1'b1 :  // A=10, B=10
               (sel == 4'b1111) ? 1'b1 :  // A=11, B=11
               1'b0;
endmodule