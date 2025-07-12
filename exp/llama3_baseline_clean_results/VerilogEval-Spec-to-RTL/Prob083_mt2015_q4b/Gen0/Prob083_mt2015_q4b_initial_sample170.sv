module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // The XOR operation (^) gives 1 when x and y are different, and 0 when they are the same. Inverting this result (~) gives us the desired output where z is 1 when x and y are the same.

endmodule