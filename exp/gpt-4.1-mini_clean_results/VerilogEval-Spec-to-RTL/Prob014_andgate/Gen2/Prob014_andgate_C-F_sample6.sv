module TopModule(
    input  a,
    input  b,
    output out
);

wire and_out;

// Instantiate primitive AND gate explicitly for clear hardware mapping
and U_and (and_out, a, b);

// Continuous assignment connects output to primitive output for clarity and synthesis friendliness
assign out = and_out;

endmodule