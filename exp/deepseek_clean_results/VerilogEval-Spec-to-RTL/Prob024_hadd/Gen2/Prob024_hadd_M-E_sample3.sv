module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is equivalent to a ? ~b : b
    assign sum = a ? ~b : b;
    
    // Carry-out remains the same as traditional implementation
    assign cout = a & b;
endmodule