module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    assign out = ~(in1 ^ in2) ^ in3; // Directly compute the output using a single logical expression

    // Alternatively, we can also use the following expression, which is logically equivalent
    // assign out = (in1 == in2) ^ in3; // This expression uses the equality operator to simplify the XNOR operation

endmodule