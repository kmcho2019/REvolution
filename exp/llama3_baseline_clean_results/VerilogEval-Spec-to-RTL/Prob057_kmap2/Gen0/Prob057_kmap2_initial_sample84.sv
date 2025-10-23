module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Based on the Karnaugh map, we can derive the Boolean expression for 'out'
// The simplified expression after analyzing the map is:
// out = (a'b + a'c'd + abd' + ac'd' + bcd + ab'cd')
assign out = (b && !a) || (!c && !d && !a) || (a && b && !d) || (a && !c && !d) || (b && c && d) || (a && !b && c && d);

endmodule