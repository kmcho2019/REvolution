module TopModule (
    input  a,
    input  b,
    output out
);
    assign out = ~(a | b); // Direct NOR operation using built-in operators
endmodule