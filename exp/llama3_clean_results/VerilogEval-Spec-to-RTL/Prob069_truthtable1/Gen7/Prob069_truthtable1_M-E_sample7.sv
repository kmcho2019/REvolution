module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// First, we create an intermediate signal 'g' that represents the result of the combination of x3 and x2
wire g;
assign g = x2 &&!x3;

// Then, we create another intermediate signal 'h' that represents the result of the combination of x1 and x3
wire h;
assign h = x1 && x3;

// Finally, we use the intermediate signals 'g' and 'h' to produce the output 'f'
assign f = g || h || (x2 && x1);

endmodule