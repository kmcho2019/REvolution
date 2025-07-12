module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Combinational output q:
    // q = 1 when at least one of {a, b} and at least one of {c, d} is high.
    // Corresponds to q = (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);

endmodule