module TopModule (
    input in,
    output out
);
    // Use a tri-state buffer with always-enabled control
    bufif1 my_buf(out, in, 1'b1);
endmodule