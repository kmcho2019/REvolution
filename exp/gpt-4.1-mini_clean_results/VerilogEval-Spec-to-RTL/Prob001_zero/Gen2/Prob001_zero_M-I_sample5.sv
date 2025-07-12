module TopModule(output wire zero);
    // Explicitly declare a localparam constant zero
    localparam logic const_zero = 1'b0;
    assign zero = const_zero;
endmodule