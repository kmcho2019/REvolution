// TopModule implements a half adder using XOR and AND operators directly
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;
assign cout = a & b;
endmodule