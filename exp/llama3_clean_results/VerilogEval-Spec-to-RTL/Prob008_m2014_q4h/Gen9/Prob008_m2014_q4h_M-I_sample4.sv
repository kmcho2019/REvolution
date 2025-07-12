module TopModule(
    input  in,
    output out
);
// Adding a buffer to the input signal to reduce switching activity
wire buffered_in;
assign buffered_in = in;
assign out = buffered_in;
endmodule