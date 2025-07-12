module TopModule(output wire zero);
    // Local parameter explicitly defining constant zero
    localparam ZERO_CONST = 1'b0;

    // Directly assign constant zero to output
    assign zero = ZERO_CONST;
endmodule