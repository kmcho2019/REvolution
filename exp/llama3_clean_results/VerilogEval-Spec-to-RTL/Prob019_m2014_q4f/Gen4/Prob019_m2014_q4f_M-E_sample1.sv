module TopModule(
    input in1,
    input in2,
    output out
);

// Implementing the logic using a multiplexer.
// in1 acts as the select line.
// When in1 is high, out = ~in2; when in1 is low, out = 0.
assign out = in1 ? ~in2 : 1'b0;

endmodule