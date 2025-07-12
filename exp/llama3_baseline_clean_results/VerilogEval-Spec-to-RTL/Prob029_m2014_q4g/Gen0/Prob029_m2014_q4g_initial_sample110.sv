module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    // XNOR operation using equality operator
    // then XOR the result with 'in3'
    assign out = (in1 == in2) ^ in3;
endmodule