module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Alternative XNOR operator syntax, same functionality
endmodule