module TopModule(
    input  a,
    input  b,
    output out
);
// Directly assign the AND operation result to out, ensuring minimal area and power usage
assign out = a & b;

endmodule