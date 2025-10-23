module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire axorb = a ^ b;
    assign sum = axorb ^ cin;
    assign cout = (a & b) | (cin & axorb);
endmodule