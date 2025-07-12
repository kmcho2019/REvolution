module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

// Using the ternary operator for directness and efficiency, while maintaining simplicity
assign out = a ? 1'b1 : (b || c);

endmodule