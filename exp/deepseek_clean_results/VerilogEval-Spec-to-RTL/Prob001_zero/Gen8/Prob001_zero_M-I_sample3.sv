module TopModule (
    output zero
);
    // Most explicit constant zero declaration
    localparam CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule