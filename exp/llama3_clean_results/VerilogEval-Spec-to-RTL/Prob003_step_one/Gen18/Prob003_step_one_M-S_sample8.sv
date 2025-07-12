// TopModule: Always drives output 'one' high with simplified constant assignment.
module TopModule (
    output logic one
);

// Directly assign the constant value to the output 'one'.
assign one = 1'b1;

endmodule