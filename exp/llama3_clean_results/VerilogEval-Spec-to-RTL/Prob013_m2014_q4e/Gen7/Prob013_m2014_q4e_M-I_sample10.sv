module TopModule(
    input  in1,
    input  in2,
    output out
);

// The NOR gate is implemented by inverting the result of the OR operation
// between in1 and in2.
assign out = ~(in1 | in2);

endmodule