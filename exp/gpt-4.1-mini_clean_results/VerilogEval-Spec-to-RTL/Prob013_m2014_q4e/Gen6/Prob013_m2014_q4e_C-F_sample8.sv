module TopModule (
    input in1,
    input in2,
    output out
);
    // Use built-in nor primitive for a clean, modular, and efficient NOR gate implementation
    nor u_nor (out, in1, in2);
endmodule