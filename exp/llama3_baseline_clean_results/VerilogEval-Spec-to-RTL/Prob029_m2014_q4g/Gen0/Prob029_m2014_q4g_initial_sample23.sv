module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    // The XOR and XNOR operations can be directly implemented using the ^ (XOR) and ~ (NOT) operators in Verilog.
    // For XNOR, we use the property that A XNOR B = (A XOR B)'.
    // However, since Verilog does not directly support the XNOR operator, we will use the above property.
    assign out = ~(in1 ^ in2) ^ in3;
    // The above line first computes the XNOR of in1 and in2 by XORing them and then inverting the result.
    // Then it XORs this result with in3 to get the final output.

endmodule