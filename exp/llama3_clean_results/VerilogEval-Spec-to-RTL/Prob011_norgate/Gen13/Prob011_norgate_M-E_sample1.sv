// Novel Module TopModule implements a NOR gate using an OR gate followed by a NOT gate.
module TopModule(
    input  a,
    input  b,
    output out
);

// Intermediate signal to hold the result of the OR operation
wire or_result;

// OR gate
assign or_result = a | b;

// NOT gate applied to the result of the OR operation
assign out = ~or_result;

endmodule