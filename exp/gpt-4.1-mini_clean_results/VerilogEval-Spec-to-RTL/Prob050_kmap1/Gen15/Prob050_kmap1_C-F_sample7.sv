// TopModule implements the K-map function: out=1 except when a=0, b=0, c=0
// This corresponds to the simple logic: out = a | b | c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Output is high if any input is high,
    // matching K-map minterms except for (a,b,c) = 000 which yields 0.
    assign out = a | b | c;
endmodule