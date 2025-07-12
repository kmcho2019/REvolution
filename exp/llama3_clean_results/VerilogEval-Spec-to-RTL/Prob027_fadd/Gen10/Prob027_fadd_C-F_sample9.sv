module TopModule(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic cout,
    output logic sum
);

// Direct implementation of full adder logic using basic gates
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule