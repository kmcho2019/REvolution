module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Map inputs to ab and cd:
    // ab = {a,b}, cd = {c,d}
    // Use combinational logic to assign out based on the table:
    // Rows: cd = 00,01,11,10
    // Cols: ab = 00,01,11,10

    assign out = 
        (c == 0 && d == 0 && ((a == 0 && b == 0) || (a == 0 && b == 1) || (a == 1 && b == 0))) || // cd=00, ab=00,01,10
        (c == 0 && d == 1 && ((a == 0 && b == 0) || (a == 1 && b == 0))) ||                    // cd=01, ab=00,10
        (c == 1 && d == 1 && ((a == 0 && b == 1) || (a == 1 && b == 1) || (a == 1 && b == 0))) || // cd=11, ab=01,11,10
        (c == 1 && d == 0 && ((a == 0 && b == 0) || (a == 0 && b == 1)));                      // cd=10, ab=00,01

endmodule