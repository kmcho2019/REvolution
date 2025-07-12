module TopModule(output wire zero);
    // Local parameter for constant zero, signaling intent explicitly
    localparam logic ZERO_CONST = 1'b0;

    // Assign the constant zero to output
    assign zero = ZERO_CONST;
endmodule