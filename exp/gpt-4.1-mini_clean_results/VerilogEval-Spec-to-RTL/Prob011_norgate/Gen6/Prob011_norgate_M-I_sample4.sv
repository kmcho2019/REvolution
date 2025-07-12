module TopModule (
    input  a,
    input  b,
    output out
);
    // Use the bitwise NOR operator for concise expression of NOR gate
    assign out = ~(a | b); // Equivalent to: assign out = ~|{a,b};
endmodule