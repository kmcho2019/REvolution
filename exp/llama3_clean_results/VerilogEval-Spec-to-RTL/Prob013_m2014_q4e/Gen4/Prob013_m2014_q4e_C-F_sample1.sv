module TopModule(
    input  logic in1,
    input  logic in2,
    output logic out
);

// Implement the NOR gate using the logical NOT operator to invert the result of a logical OR operation
assign out = ~(in1 | in2);

endmodule