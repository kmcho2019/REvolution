module TopModule(
    input  in1,
    input  in2,
    output out
);

// Maintaining a straightforward implementation for clarity and synthesis optimization
assign out = in1 & ~in2;

endmodule