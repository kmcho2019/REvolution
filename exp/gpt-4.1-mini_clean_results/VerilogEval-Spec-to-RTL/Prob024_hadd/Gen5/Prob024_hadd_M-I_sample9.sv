module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

// sum and cout as continuous assign statements for consistent RTL style
assign sum = a ^ b;
assign cout = a & b;

endmodule