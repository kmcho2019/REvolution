module TopModule (
    input in,
    output out
);
    bufif1 buffer(out, in, 1'b1);  // Tri-state buffer always enabled
endmodule