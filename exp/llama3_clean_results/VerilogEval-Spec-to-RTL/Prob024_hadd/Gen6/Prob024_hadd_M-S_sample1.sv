module TopModule (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

assign sum = a ^ b;  // Calculate sum using XOR
assign cout = a & b; // Calculate carry-out using AND

endmodule