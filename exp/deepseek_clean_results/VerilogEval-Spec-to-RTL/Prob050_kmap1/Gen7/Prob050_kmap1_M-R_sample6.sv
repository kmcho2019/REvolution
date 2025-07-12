module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Direct implementation using OR operation
    assign out = a | b | c;
endmodule