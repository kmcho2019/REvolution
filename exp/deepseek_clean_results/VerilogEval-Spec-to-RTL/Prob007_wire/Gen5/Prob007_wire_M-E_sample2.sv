module TopModule (
    input in,
    output out
);
    bufif1 b1(out, in, 1'b1);  // Always enabled buffer
endmodule