module TopModule (
    input in,
    output out
);
    // Implement as tri-state buffer with always-on enable
    bufif1 my_buf(out, in, 1'b1);
endmodule