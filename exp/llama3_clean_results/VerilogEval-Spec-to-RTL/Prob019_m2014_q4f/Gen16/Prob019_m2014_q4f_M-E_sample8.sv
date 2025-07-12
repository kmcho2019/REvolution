module TopModule(
    input in1,
    input in2,
    output out
);

// Explicitly model an inverter for in2
wire not_in2;
assign not_in2 = ~in2;

// Explicitly model an AND gate for in1 and not_in2
assign out = in1 & not_in2;

endmodule