module TopModule(
    input  in1,
    input  in2,
    output out
);
// Maintaining the same assign statement for simplicity and directness.
assign out = in1 & ~in2;
endmodule