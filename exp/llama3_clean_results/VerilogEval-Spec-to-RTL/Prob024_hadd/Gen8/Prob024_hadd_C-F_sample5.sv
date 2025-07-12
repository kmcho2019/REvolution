module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly compute sum and carry-out using XOR and AND operators
assign sum = a ^ b;
assign cout = a & b;
endmodule