module TopModule (
    input in,
    output out
);
    // Implement as a tri-state buffer with always-enabled control
    bufif1 my_buf(out, in, 1'b1);  // Control pin hardwired to 1
endmodule