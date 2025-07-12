module TopModule (
    input  wire a,      // First input bit
    input  wire b,      // Second input bit
    output reg  sum,    // Sum output (a XOR b)
    output reg  cout    // Carry output (a AND b)
);

always @(*) begin
    sum  = a ^ b;  // Sum is XOR of inputs
    cout = a & b;  // Carry-out is AND of inputs
end

endmodule