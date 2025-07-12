module TopModule (
    input in,
    output out
);
    // Implement as tri-state buffer with permanent enable
    bufif1 mybuf(out, in, 1'b1);
endmodule