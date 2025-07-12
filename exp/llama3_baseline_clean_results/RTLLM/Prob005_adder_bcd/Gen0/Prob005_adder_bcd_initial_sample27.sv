module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_wire;
    assign sum_wire = {A[3], A} + {B[3], B} + Cin;
    
    // Apply BCD correction if sum exceeds 9
    wire [3:0] sum_corrected;
    wire Cout_wire;
    assign Cout_wire = sum_wire[4]; // Cout is the most significant bit of the sum
    assign sum_corrected = (sum_wire < 5'd10) ? sum_wire[3:0] : sum_wire[3:0] + 4'd6;
    
    // Output the corrected sum and carry
    assign Sum = sum_corrected;
    assign Cout = Cout_wire;

endmodule