module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Since 'b' being 1 is a direct condition for output 1, we'll focus on that.
// However, the K-map also indicates output 1 when a=0, b=0, and c=0, considering 'd'.
// But our main simplification condition is b=1.

assign out = (b) || (!a && !c);

endmodule