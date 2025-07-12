module TopModule (
    input  wire in,
    output wire out
);

    // Direct wire connection: output follows input with no added logic or registers.
    // This simple assignment ensures minimal area, power, and optimal performance.
    assign out = in;

endmodule