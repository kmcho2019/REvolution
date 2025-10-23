module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Derived from Karnaugh map minimal groups:
// Group 1 (cd=00): ab=00,01,10 => ~c & ~d & (~a | ~b)
// Group 2 (cd=01): ab=00,10     => ~c &  d & ~b
// Group 3 (cd=10): ab=00,01     =>  c & ~d & ~a
// Group 4 (cd=11): ab=01,10,11  =>  c &  d & (a | b)

assign out = (nc & nd & (na | nb)) |
             (nc &  d &  nb)       |
             ( c & nd &  na)       |
             ( c &  d & (a | b));

endmodule