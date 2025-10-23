module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Intermediate signals to potentially aid in synthesis or readability
wire or_bc;
wire and_abc;

// Calculate the OR of b and c
assign or_bc = b || c;

// Calculate the AND of a with the OR of b and c
assign and_abc = a && or_bc;

// Final output q is the OR of the intermediate signals
assign q = or_bc || and_abc;

endmodule