module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Binary addition
    wire [4:0] binary_sum = A + B + Cin;
    
    // Stage 2: BCD correction
    wire overflow = (binary_sum[4]) ||              // Carry out from binary addition
                   (binary_sum[3:0] > 4'd9);       // Sum exceeds 9
    
    // Corrected sum (add 6 if overflow occurred)
    assign Sum = overflow ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];
    
    // Carry out generation
    assign Cout = overflow;

endmodule