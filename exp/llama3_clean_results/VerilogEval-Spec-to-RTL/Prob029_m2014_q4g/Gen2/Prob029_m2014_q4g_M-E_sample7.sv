module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly compute the output 'out' using a minimized Boolean expression
assign out = (in1 & in2) ^ (!in1 & !in2) ^ in3;

endmodule