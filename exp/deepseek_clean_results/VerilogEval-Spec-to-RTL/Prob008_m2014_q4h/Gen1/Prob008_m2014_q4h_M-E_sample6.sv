module TopModule (
    input in,
    output out
);
    // Tri-state buffer implementation
    bufif1 my_buffer(out, in, 1'b1);  // Permanent enable
endmodule