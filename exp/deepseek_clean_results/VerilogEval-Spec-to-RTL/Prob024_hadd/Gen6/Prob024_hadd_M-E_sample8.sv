module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // MUX implementation of XOR for sum
    assign sum = (a == 1'b0) ? b : ~b;
    
    // MUX implementation of AND for carry-out
    assign cout = (a == 1'b1) ? b : 1'b0;
endmodule