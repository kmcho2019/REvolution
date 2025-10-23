module TopModule (
    input a,
    input b,
    output out
);
    wire or_out;
    assign or_out = a | b;
    assign out = ~(or_out & or_out);  // NAND with same inputs acts as NOT
endmodule