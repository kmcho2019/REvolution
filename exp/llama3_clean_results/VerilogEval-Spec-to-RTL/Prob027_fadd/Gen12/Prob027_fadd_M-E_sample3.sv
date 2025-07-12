module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Using K-map reduction, the SOP expressions for sum and cout are derived as follows:
// sum = a ^ b ^ cin
// cout = (a & b) | (a & cin) | (b & cin)

// Directly implementing these expressions in Verilog:
assign sum = ~(a & b & cin) & ~(~a & ~b & ~cin) & ~(~a & b & ~cin) & ~(a & ~b & ~cin) & (a & ~b & cin) & (~a & b & cin) & (a & b & ~cin) | (a & ~b & ~cin) & (~a & b & ~cin) & (~a & ~b & cin);
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule