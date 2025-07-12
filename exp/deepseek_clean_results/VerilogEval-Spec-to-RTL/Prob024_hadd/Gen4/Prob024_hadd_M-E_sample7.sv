module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is b when a=0, ~b when a=1 (equivalent to XOR)
    assign sum = a ? ~b : b;
    // Carry-out remains the same as standard implementation
    assign cout = a & b;
endmodule