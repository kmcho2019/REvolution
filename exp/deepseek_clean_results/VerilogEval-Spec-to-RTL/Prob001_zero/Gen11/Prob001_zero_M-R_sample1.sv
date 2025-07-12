module TopModule (
    output zero
);
    // Refactored version using intermediate wire
    wire internal_zero;
    assign internal_zero = 1'b0;
    assign zero = internal_zero;
endmodule