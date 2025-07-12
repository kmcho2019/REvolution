module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum calculation using MUX: sum = a ? ~b : b
    assign sum = a ? ~b : b;
    
    // Carry-out calculation using MUX: cout = a ? b : 0
    assign cout = a & b;
endmodule