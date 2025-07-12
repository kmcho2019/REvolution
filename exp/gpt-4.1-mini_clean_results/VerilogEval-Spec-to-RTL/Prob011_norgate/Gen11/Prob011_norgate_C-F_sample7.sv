module TopModule (
    input  a,
    input  b,
    output wire out  // Explicitly declare output as wire for clarity
);

    // Implement 2-input NOR gate using continuous assignment
    assign out = ~(a | b);

endmodule