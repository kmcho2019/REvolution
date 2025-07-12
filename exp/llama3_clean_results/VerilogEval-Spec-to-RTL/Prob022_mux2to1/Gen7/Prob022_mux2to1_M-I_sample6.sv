module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Explicitly define the multiplexer's behavior using logical operators
assign out = (sel == 1'b0) ? a : b;

// Alternatively, to make it even more explicit and potentially more synthesizable:
// assign out = (sel & b) | (~sel & a);

endmodule