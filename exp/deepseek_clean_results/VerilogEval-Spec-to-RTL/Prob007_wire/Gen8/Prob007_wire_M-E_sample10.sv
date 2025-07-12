module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire ctrl = 1'b1;  // Always enabled
    tranif1 tg(out, in, ctrl);
endmodule