module TopModule(
    input in1,
    input in2,
    output out
);

// Using a single assign statement for simplicity and potential synthesis optimization
assign out = in1 & ~in2;

endmodule