module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b; // Direct XOR operation for sum
assign cout = a & b; // Direct AND operation for carry-out
endmodule