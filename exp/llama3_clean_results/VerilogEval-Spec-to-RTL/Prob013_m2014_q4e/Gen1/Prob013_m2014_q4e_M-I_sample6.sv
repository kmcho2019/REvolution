module TopModule(
    input  in1,
    input  in2,
    output out
);

// Explicitly using a NOT gate followed by an OR gate for educational purposes
wire or_result;
assign or_result = in1 | in2;
assign out = ~or_result;

endmodule