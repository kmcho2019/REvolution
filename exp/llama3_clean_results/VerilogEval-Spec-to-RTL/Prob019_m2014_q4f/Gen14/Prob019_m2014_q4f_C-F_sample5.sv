module TopModule(
    input  in1,
    input  in2,
    output out
);

// Direct implementation with clear notation for inversion
assign out = in1 && !in2;

endmodule