module TopModule (
    input in,
    output out
);
    // Implement as a tri-state buffer with always-enabled control
    bufif1 my_buffer(out, in, 1'b1);
endmodule