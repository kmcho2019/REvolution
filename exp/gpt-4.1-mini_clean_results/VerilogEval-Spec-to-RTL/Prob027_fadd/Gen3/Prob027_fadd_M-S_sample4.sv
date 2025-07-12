module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire [1:0] result = a + b + cin;
    assign sum = result[0];
    assign cout = result[1];
endmodule