module TopModule (
    input in,
    output out
);
    // Tri-state buffer implementation with permanent enable
    bufif1 my_buffer(out, in, 1'b1);  // Always enabled buffer
endmodule