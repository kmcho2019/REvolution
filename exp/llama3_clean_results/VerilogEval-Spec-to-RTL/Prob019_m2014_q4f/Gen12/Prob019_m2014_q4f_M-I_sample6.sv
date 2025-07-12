module TopModule(
    input  in1,
    input  in2,
    output out
);

// Utilizing the same logic as before but considering potential synthesis optimizations
assign out = in1 & (~in2);

endmodule