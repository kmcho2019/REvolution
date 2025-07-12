module TopModule(
    input in,
    output out
);
// Explicitly assigning out to in, relying on synthesis tool to optimize
assign out = in;
endmodule