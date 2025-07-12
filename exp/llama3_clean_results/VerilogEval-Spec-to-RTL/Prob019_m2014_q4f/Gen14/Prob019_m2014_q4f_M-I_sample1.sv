module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a continuous assignment with explicit inversion and gate-level implementation
assign out = in1 & (~in2);

endmodule