// Define the TopModule with a behavioral implementation of a half adder
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Calculate the sum using the Boolean algebraic expression
assign sum = (a || b) && !(a && b);
// Calculate the carry-out using the AND operation
assign cout = a && b;
endmodule