module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    // Directly express the XNOR followed by XOR as a single operation
    assign out = ~(in1 ^ in2) ^ in3;

    // Alternatively, consider expressing the logic using basic gates
    // assign out = ~(in1 ^ in2) ^ in3; // This is the same as above, but considering basic gates didn't yield a simpler form

endmodule