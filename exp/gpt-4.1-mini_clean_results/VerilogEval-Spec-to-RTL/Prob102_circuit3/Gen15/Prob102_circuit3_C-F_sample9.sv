module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Intermediate wires for input ORs improve code readability
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Output is high only if (a OR b) and (c OR d) are both high
    assign q = ab_or & cd_or;

endmodule