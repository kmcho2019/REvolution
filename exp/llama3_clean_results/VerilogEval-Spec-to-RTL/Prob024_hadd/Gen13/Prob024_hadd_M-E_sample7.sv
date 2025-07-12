// Define a module for a 2-to-1 multiplexer
module MUX2TO1(
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic out
);
assign out = (sel) ? b : a;
endmodule

// Define the TopModule using a multiplexer-based approach
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
logic and_result;

// Compute the carry-out (AND of a and b)
assign and_result = a & b;
assign cout = and_result;

// Use a multiplexer to compute the sum based on the carry-out condition
MUX2TO1 u_mux(a ^ b, 1'b0, and_result, sum);
endmodule