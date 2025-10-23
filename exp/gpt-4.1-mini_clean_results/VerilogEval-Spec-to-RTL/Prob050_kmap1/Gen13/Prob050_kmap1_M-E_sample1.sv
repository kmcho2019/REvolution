module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or;

    // First-level OR gate for b and c
    assign bc_or = b | c;

    // Final OR gate combines bc_or and a
    assign out = a | bc_or;
endmodule