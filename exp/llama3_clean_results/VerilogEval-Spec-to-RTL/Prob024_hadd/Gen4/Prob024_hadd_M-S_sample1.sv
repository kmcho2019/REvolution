module TopModule (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

always_comb begin
    // Use bitwise XOR for the sum and bitwise AND for the carry-out
    sum = a ^ b;
    cout = a & b;
end

endmodule