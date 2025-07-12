module TopModule (
    output zero
);
    // Optimal implementation - permanently outputs LOW
    // Zero timing paths, minimal power, smallest possible area
    assign zero = 1'b0;
endmodule