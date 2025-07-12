module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Inverted inputs for clarity and reuse
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Common OR term reused in logic
wire a_or_b = a | b;

always @* begin
    // Combinational logic derived from Karnaugh map minimized expression:
    // out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))
    if ((nd & na) | (nc & nb) | (c & d & a_or_b))
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule