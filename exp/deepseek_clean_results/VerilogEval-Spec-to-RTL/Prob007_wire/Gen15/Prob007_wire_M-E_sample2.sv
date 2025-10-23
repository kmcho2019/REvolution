module TopModule (
    input in,
    output out
);
    bufif1 my_buffer(out, in, 1'b1);  // Always enabled buffer
endmodule