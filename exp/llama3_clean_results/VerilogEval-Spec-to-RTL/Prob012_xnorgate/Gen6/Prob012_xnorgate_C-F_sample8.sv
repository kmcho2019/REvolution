module TopModule(
    input  a,
    input  b,
    output out
);

// Use the equality operator (==) to compare the inputs a and b
// This directly implements the XNOR functionality and is efficient in terms of area and power consumption
assign out = ~(a ^ b); // this line was replaced with the one below
assign out = (a == b); // equality operator directly implements XNOR

endmodule