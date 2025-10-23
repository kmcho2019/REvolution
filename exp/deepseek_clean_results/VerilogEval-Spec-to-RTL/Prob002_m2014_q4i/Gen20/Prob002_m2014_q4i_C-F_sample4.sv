module TopModule #(
    parameter VALUE = 1'b0  // Configurable output value (default 0)
) (
    output out
);
    // Direct constant assignment with configurable default
    assign out = VALUE;
endmodule