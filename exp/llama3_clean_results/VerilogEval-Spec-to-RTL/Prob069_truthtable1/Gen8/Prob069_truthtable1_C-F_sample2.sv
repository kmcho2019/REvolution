module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Create an intermediate signal 'g' that represents the result of the combination of x2 and x3
wire g;
assign g = x2 &&!x3;

// Use the intermediate signal 'g' and the inputs x1 and x3 to produce the output 'f'
assign f = g || (x1 && x3);

endmodule