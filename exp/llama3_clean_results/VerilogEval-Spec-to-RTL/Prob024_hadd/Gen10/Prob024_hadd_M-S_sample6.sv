// TopModule directly implements half adder logic using XOR and AND operations
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;
assign cout = a & b;
endmodule