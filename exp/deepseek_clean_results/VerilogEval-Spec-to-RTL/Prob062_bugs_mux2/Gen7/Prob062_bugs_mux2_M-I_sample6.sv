module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Alternative implementation using case statement
    // This might synthesize more efficiently in some technologies
    assign out = sel ? b : a;

    // Alternatively, we could use this bitwise implementation:
    // assign out = (a & {8{~sel}}) | (b & {8{sel}});
    // But the ternary operator is typically preferred for readability

endmodule