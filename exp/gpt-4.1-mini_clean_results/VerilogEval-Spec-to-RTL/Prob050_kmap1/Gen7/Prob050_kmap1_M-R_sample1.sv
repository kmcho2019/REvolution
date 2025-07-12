module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Implementing the function:
    // out = (b OR c) OR (NOT b AND NOT c AND a)
    assign out = (b | c) | (~b & ~c & a);
endmodule