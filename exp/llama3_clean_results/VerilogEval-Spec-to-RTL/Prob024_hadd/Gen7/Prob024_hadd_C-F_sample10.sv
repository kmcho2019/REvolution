module TopModule (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

always @(*) begin
    sum = a ^ b; // XOR operation for sum
    cout = a & b; // AND operation for carry-out
end

endmodule