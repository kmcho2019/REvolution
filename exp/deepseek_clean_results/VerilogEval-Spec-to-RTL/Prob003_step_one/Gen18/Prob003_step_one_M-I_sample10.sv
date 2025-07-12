module TopModule (
    output one
);
    // This module outputs a constant logic high (1)
    parameter CONST_ONE = 1'b1;
    assign one = CONST_ONE;
endmodule