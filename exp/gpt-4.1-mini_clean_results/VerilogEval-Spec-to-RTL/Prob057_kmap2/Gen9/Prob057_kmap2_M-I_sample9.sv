module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;

// Minimal SOP expression from Karnaugh map:
// out = ( ~d & ~a ) | ( ~c & ~b ) | ( c & d & (a | b) )
assign out = ( (~d) & na ) | ( (~c) & nb ) | ( c & d & (a | b) );

endmodule