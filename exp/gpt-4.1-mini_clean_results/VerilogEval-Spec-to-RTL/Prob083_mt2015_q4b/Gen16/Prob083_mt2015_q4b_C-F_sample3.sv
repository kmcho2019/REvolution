module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// Using bitwise XNOR operator (^~) for clear and concise synthesis intent.
assign z = x ^~ y;

endmodule