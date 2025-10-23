module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Intermediate signals to break down the logic
wire ab_not, c_not;

assign ab_not = ~(a | b);
assign c_not = ~c;

// Use the intermediate signals to simplify the logic expression
assign out = (a) | (ab_not & c) | (b & c);

endmodule