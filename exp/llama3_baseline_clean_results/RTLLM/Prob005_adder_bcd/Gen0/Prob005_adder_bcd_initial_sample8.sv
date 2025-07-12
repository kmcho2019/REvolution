module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_wire = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction
    assign Sum = (sum_wire > 9) ? sum_wire + 6 : sum_wire[3:0];

    // Generate carry-out if the sum exceeds 9
    assign Cout = (sum_wire > 9) ? 1'b1 : sum_wire[4];

endmodule