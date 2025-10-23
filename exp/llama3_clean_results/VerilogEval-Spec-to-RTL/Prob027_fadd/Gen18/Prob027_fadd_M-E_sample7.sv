module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

wire a_and_b, a_or_b;
assign a_and_b = a & b;
assign a_or_b = a | b;

assign sum = (a ^ b) ^ cin;
assign cout = (a_and_b) | (a & cin) | (b & cin);

// Alternatively, implementing with multiplexers as described
// assign sum = cin? (a ^ b ^ 1) : (a ^ b);
// assign cout = cin? (a_or_b) : a_and_b;

endmodule