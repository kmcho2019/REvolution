module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a == b); // Directly compare inputs a and b for equality

endmodule