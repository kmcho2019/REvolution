// Novel solution using basic logic gates
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Use OR gates to implement the logic
assign out = a | (b | c);

endmodule