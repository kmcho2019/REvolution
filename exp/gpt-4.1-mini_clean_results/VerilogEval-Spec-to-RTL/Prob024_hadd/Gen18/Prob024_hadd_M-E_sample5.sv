module TopModule (
    input  wire a,
    input  wire b,
    output reg  sum,
    output reg  cout
);

always @(*) begin
    sum  = a ^ b;   // sum is XOR of a and b
    cout = a & b;   // carry out is AND of a and b
end

endmodule