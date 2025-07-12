// TopModule with MUX-based implementation
module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Use in1 and in2 to decide whether in3 should pass through or be inverted
assign out = (in1 == in2) ? ~in3 : in3;

endmodule