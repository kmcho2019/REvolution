module TopModule (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

always_comb begin
    sum = a ^ b;  // Calculate sum using XOR
    cout = a & b; // Calculate carry-out using AND
end

endmodule