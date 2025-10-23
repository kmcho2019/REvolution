module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Use a multiplexer to selectively enable or disable the OR operation
assign q = (a == 0) ? (b | c) : (b | c);

endmodule