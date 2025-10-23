module TopModule (
    output zero
);
    // Direct constant assignment - most efficient implementation
    // for always-LOW output (zero power, zero delay, minimal area)
    assign zero = 1'b0;
endmodule