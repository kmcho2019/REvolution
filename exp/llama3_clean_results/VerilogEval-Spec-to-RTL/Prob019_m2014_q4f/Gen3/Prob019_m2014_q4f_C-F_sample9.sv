module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a continuous assignment for simplicity and efficiency
assign out = in1 & (~in2);

endmodule