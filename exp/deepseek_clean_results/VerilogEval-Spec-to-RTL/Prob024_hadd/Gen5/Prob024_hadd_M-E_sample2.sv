module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // MUX-based sum calculation
    assign sum = a ? ~b : b;
    
    // AND-based carry calculation (which is effectively a MUX)
    assign cout = a & b;

endmodule