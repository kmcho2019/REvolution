module TopModule(
    output wire out
);
    // Define a local parameter for constant zero, enhancing readability and maintainability
    localparam logic ZERO = 1'b0;

    // Drive output permanently low using a named constant for clarity and synthesis efficiency
    assign out = ZERO;
endmodule