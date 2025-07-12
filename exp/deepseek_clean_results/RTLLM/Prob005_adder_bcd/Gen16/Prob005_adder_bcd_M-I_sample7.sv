module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition stage
    wire [3:0] sum_binary = A + B + Cin;
    wire carry_binary = (A + B + Cin) > 4'd15;  // Simplified carry detection

    // Overflow detection (sum >9)
    wire overflow = carry_binary | 
                   (sum_binary[3] & sum_binary[2]) | 
                   (sum_binary[3] & sum_binary[1]);

    // Precompute both possible results
    wire [3:0] sum_corrected = sum_binary + 4'd6;
    wire [3:0] sum_result = overflow ? sum_corrected : sum_binary;

    // Output assignment with clock gating for correction logic
    assign Sum = sum_result;
    assign Cout = overflow;

endmodule