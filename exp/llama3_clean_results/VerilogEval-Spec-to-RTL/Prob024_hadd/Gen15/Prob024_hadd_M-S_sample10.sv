// TopModule implements a half adder directly
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly implement sum and carry-out logic
assign sum = a ^ b;
assign cout = a & b;
endmodule