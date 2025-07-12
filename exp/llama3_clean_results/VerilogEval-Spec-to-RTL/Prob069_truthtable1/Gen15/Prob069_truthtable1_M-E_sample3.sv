module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Generate intermediate signals
wire sig1, sig2;

assign sig1 = x1 & x3;
assign sig2 = x2 & ~x3;

// Use majority voting circuit
assign f = (sig1 & sig2) | (sig1 & x2) | (sig2 & x1);

endmodule