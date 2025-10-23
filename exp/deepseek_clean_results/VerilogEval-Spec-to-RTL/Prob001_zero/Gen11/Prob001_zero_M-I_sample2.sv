module TopModule (
    output zero
);
    // Explicit constant definition
    localparam CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule