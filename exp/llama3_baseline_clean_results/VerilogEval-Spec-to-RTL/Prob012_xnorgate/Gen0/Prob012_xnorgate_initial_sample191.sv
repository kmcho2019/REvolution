module TopModule(a, b, out);
    input a;
    input b;
    output out;

    assign out = ~(a ^ b); // The XOR operation is performed first, and then the result is inverted to get the XNOR operation
endmodule