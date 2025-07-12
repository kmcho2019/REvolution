module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the logic based on the corrected understanding of the Karnaugh map
assign out = (
    (!c && !d && (!a || !b || (a && b))) ||  // cd = 00
    (c && !d && (!a && !b || (a && !b))) ||  // cd = 01
    (c && d && (a && !b || (!a && b))) ||    // cd = 11
    (!c && d && (!a && !b || (a && !b)))     // cd = 10
);

endmodule