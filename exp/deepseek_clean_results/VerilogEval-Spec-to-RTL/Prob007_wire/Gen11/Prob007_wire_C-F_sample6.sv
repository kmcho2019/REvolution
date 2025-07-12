module TopModule (
    input in,
    output out
);
    // Direct wire connection - optimal PPA (0 timing, minimal power/area)
    assign out = in;
endmodule