module TopModule(
    input  in1,
    input  in2,
    output out
);

// The current implementation is already minimal and straightforward.
// To maintain simplicity and minimize area and power, we keep the design as is.
assign out = ~(in1 | in2);

endmodule