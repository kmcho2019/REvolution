module TopModule #(
    parameter DRIVE_STRENGTH = 1  // Default drive strength
) (
    input in,
    output out
);
    // NOT gate with configurable drive strength
    assign (strong0, strong1) out = ~in;
endmodule