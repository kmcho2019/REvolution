module TopModule (
    input in,
    output out
);
    // Implement as a transmission gate that's always on
    tranif1 tg(out, in, 1'b1);  // Always enabled transmission gate
endmodule