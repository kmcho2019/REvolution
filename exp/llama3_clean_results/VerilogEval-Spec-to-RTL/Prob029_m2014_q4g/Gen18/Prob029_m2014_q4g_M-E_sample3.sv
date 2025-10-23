module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Direct implementation based on simplified logic
assign out = ((in1 && in2 && !in3) || (!in1 && !in2 && !in3) || (in1 && !in2 && !in3) || (!in1 && in2 && in3));

endmodule