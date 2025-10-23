module TopModule(output wire zero);
    // Local parameter defining constant zero for clarity and potential reusability
    localparam logic const_zero = 1'b0;
    // Assign output to constant zero localparam
    assign zero = const_zero;
endmodule