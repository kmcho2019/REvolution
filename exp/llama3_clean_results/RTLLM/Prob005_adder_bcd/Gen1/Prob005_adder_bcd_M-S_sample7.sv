module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output  [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output      Cout  // Carry-out output
);

    assign Sum = (A + B + Cin) > 9 ? (A + B + Cin + 6)[3:0] : (A + B + Cin)[3:0];
    assign Cout = (A + B + Cin) > 9 ? 1'b1 : 1'b0;

endmodule