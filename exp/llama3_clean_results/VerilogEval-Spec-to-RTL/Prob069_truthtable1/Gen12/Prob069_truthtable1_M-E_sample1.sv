module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implement the logic for 'f' being '0'
wire f_zero = (x3 & x2 & ~x1) | (~x3 & ~x2);

// Invert the result to get 'f'
assign f = ~f_zero;

endmodule