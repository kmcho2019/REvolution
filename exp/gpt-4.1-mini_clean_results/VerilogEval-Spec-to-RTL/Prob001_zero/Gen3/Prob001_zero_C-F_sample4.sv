module TopModule(
    output zero
);
    // Constant parameter representing zero for clarity and explicitness
    localparam ZERO_CONST = 1'b0;

    // Continuous assignment of the constant zero to the output
    assign zero = ZERO_CONST;
endmodule