module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    // Count the number of '1's among inputs
    integer sum;
    sum = a + b + c + d;
    // q is 1 if sum is even, else 0
    q = (sum % 2 == 0) ? 1'b1 : 1'b0;
end

endmodule