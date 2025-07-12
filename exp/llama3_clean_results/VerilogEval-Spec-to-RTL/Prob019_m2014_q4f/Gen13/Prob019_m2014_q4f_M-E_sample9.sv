module TopModule(
    input in1,
    input in2,
    output out
);

// Invert in2
wire inv_in2;
assign inv_in2 = ~in2;

// Use a MUX to implement the logic
// When in1 is high, select inv_in2; when in1 is low, select 0 (since out should be low)
assign out = in1? inv_in2 : 1'b0;

endmodule