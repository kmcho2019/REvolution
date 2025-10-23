module TopModule(
    input a,
    input b,
    input c,
    output out
);

wire temp1, temp2;

assign temp1 = b & c;
assign temp2 = b & ~c;
assign out = a | temp1 | temp2 | (~b & c);

endmodule