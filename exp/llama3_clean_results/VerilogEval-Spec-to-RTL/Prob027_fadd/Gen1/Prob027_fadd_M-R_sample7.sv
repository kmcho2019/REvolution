module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

always @(*) begin
    sum = a ^ b ^ cin;
    cout = (a & b) | (a & cin) | (b & cin);
end

endmodule