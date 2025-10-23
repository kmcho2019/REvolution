module TopModule(
    input in,
    output out
);
    // Use a structural buf primitive for explicit direct buffering
    buf (out, in);
endmodule