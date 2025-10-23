module TopModule(
    input x,
    input y,
    output z
);

wire not_y;
wire and_result;

// Calculate the inverse of y
assign not_y = ~y;

// Perform the AND operation between x and the inverse of y
assign and_result = x & not_y;

// Assign the final result to z
assign z = and_result;

endmodule