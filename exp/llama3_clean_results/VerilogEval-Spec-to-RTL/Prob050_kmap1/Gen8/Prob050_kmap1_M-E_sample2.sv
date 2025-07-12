module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Using a multiplexer to select between 'a' and 1 based on 'b' and 'c'
wire sel = b | c;
assign out = (sel)? 1 : a;

endmodule