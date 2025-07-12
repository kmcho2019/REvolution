module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using the ^~ operator
    assign out = a ^~ b;
endmodule