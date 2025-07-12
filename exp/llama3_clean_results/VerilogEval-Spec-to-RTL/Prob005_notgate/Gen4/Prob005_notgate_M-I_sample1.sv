module TopModule(
    input  in,
    output out
);
    // Using a bufif1 (buffer with an inverter) for potential optimization
    bufif1(out, in);
endmodule