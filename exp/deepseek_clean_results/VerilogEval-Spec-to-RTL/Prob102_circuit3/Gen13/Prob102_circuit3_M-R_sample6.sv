module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Intermediate wires for OR operations
    wire ab_or;
    wire cd_or;

    // First level OR gates
    assign ab_or = a || b;
    assign cd_or = c || d;

    // Final AND gate
    assign q = ab_or && cd_or;

endmodule