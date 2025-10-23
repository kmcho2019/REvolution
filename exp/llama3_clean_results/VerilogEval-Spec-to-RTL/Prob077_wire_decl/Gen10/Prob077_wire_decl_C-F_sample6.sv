module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Declare wires for the outputs of the AND gates
wire and_out1;
wire and_out2;

// Use assign statements to implement the AND gates
assign and_out1 = a & b;
assign and_out2 = c & d;

// Declare a wire for the output of the OR gate
wire or_out;

// Use an assign statement to implement the OR gate
assign or_out = and_out1 | and_out2;

// Assign the output of the OR gate to 'out'
assign out = or_out;

// Use an assign statement to implement the NOT gate for 'out_n'
assign out_n = ~out;

endmodule