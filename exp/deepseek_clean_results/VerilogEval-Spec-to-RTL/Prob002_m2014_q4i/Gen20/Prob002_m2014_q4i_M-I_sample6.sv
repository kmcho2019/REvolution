module TopModule (
    output out
);
    parameter CONST_VAL = 1'b0;  // Configurable parameter (default 0)
    assign out = CONST_VAL;      // Same functionality, more flexible
endmodule