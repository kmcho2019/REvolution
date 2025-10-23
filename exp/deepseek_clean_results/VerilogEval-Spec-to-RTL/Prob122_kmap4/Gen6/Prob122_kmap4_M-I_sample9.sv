module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Alternative implementation that might map better to target technology
    assign out = a ^ b ^ c ^ d;

endmodule