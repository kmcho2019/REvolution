module TopModule (
    output zero
);
    // The output is always 0, which is the most power-efficient state for digital signals.
    assign zero = 1'b0;
endmodule