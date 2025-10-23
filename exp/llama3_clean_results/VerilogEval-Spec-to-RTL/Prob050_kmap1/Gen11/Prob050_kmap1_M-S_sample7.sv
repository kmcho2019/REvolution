module TopModule(
    input a,
    input b,
    input c,
    output out
);
// Directly implement the OR operation as per the Karnaugh map
assign out = a | b | c;
endmodule