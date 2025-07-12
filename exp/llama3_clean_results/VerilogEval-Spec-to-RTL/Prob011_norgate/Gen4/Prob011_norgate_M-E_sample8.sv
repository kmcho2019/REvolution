module TopModule(
    input a,
    input b,
    output out
);

// Intermediate signal to hold the result of the OR operation
wire or_result;

// Perform the OR operation
assign or_result = a | b;

// Invert the result of the OR operation to get the NOR result
assign out = ~or_result;

endmodule