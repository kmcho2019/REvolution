module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Alternative implementation using a more direct logical expression
assign out = (~in3 & (in1 == in2)) | (in3 & ~(in1 == in2));

endmodule