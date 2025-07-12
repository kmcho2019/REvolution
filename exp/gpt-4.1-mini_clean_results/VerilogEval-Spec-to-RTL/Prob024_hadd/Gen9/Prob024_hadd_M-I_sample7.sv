module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

assign sum = a ^ b;    // Sum bit: XOR of inputs
assign cout = a & b;   // Carry-out bit: AND of inputs

endmodule