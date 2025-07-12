module TopModule(output wire zero);
    localparam logic ZERO_CONST = 1'b0;
    assign zero = ZERO_CONST;
endmodule