module TopModule (
    input  wire a,      // First input bit
    input  wire b,      // Second input bit
    output reg  sum,    // Sum output (a XOR b)
    output reg  cout    // Carry output (a AND b)
);

// Half adder logic: combinational always block
always @(*) begin
    sum = a ^ b;       // sum is XOR of inputs
    cout = a & b;      // carry is AND of inputs
end

endmodule