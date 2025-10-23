module TopModule #(
    parameter OUT_VALUE = 1'b0
) (
    output out
);
    // Drive the output to the constant value defined by the parameter.
    assign out = OUT_VALUE;

    // Optional: Adding a synthesis directive to optimize the output.
    // The exact directive may vary depending on the synthesis tool being used.
    // $display("TopModule: Output always %b.", OUT_VALUE);

endmodule