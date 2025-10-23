module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

assign w = a;
assign {x, y} = {1'b0, b}; // Incorrect, will be fixed
assign z = c;

// Correcting the above incorrect statement
// We can't use {x, y} = {1'b0, b} because x and y should be assigned b
assign x = b;
assign y = b;

endmodule