module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);

    // Use built-in nor gate primitive for clear structural NOR implementation
    nor u_nor (out, in1, in2);

endmodule