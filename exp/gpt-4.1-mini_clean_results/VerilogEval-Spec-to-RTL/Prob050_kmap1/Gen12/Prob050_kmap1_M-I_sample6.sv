module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or;
    wire bc_and_n;
    
    assign bc_or = b | c;
    assign bc_and_n = ~b & ~c;
    assign out = bc_or | (bc_and_n & a);
endmodule