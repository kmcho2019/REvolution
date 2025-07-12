module TopModule(
    input  in1,
    input  in2,
    output out
);

// The existing implementation is already minimal and efficient.
// To reduce switching activity and thus potentially lower power consumption,
// ensure in1 and in2 are only changed when necessary in the larger design.
assign out = ~(in1 | in2);

endmodule