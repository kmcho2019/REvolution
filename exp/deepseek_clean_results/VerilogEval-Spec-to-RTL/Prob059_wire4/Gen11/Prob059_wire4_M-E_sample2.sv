module WirePair (
    input in,
    output out1,
    output out2
);
    assign out1 = in;
    assign out2 = in;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Simple wire connections
    assign w = a;
    assign z = c;
    
    // Use WirePair for the b->x and b->y connections
    WirePair b_duplicator (
        .in(b),
        .out1(x),
        .out2(y)
    );
endmodule