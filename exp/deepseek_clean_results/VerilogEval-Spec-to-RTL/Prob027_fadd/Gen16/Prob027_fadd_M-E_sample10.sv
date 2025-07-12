module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Carry-out: mux implementation
    assign cout = (a & b) ? 1'b1 : cin;
    
    // Sum: alternative implementation
    assign sum = (a ^ b) ? ~cin : cin;
endmodule