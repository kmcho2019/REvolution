module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum calculation using MUX logic
    // sum = (a ^ cin) ? ~b : b
    assign sum = (a ^ cin) ? ~b : b;
    
    // Carry-out calculation using MUX logic
    // cout = a ? b : cin
    assign cout = a ? b : cin;
endmodule