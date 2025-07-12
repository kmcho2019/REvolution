module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a continuous assignment with logical AND and explicit inversion for clarity and readability
assign out = in1 &&!in2;

endmodule