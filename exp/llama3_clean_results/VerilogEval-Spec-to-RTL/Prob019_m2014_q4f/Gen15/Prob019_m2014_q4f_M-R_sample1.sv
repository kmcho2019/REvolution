module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a continuous assignment with bitwise operators
assign out = in1 & ~in2;

endmodule