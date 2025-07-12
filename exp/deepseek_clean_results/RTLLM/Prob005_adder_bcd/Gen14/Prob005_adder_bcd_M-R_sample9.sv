module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute overflow condition (sum > 9)
    assign Cout = (A + B + Cin) > 9;

    // Apply BCD correction when needed
    assign Sum = Cout ? (A + B + Cin + 6) : (A + B + Cin);

endmodule