// TopModule implements half adder functionality directly
// It takes two inputs (a and b), and produces two outputs (sum and cout)
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Calculate sum as XOR of a and b
assign sum = a ^ b;
// Calculate carry-out as AND of a and b
assign cout = a & b;
endmodule