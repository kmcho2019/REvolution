module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

assign sum = a ^ b;   // Direct XOR assignment for sum
assign cout = a & b;  // Direct AND assignment for carry-out

endmodule