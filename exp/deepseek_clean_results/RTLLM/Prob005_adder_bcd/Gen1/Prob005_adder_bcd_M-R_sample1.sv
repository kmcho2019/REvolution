module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum with carry
    wire [4:0] binary_result = A + B + Cin;
    
    // Correction needed if sum >9 or carry occurred
    wire needs_correction = (binary_result[3:0] > 4'd9) || binary_result[4];
    
    // Apply correction if needed and get final sum
    assign Sum = needs_correction ? (binary_result[3:0] + 4'd6) : binary_result[3:0];
    
    // Carry out is set when correction is needed
    assign Cout = needs_correction;

endmodule