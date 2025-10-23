module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute correction condition: sum > 9 or carry occurred
    // Equivalent to checking for patterns 1010-1111 or carry-out
    wire needs_correction = (A + B + Cin > 9) | ((A + B + Cin) > 15);

    // Compute final sum with conditional correction
    assign Sum = needs_correction ? (A + B + Cin + 6) : (A + B + Cin);
    
    // Carry output is simply the correction flag
    assign Cout = needs_correction;

endmodule