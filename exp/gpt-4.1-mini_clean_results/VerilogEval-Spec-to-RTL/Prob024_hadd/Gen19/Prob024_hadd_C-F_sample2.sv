module TopModule (
    input  wire a,
    input  wire b,
    output reg  sum,
    output reg  cout
);

always @(*) begin
    sum  = a ^ b;    // sum is XOR of inputs
    cout = a & b;    // cout is AND of inputs
end

endmodule