module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The existing simplified expression is already efficient
assign out = ~(in1 ^ in2) ^ in3;

endmodule