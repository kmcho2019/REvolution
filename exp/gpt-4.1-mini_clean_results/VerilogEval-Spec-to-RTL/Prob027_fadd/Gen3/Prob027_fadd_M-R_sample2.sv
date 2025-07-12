module TopModule (
    input  a,
    input  b,
    input  cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    // partial sum of a and b
    wire ab_sum = a ^ b;
    // sum includes carry-in
    sum = ab_sum ^ cin;
    // carry out if at least two inputs are high
    cout = (a & b) | (b & cin) | (a & cin);
end

endmodule