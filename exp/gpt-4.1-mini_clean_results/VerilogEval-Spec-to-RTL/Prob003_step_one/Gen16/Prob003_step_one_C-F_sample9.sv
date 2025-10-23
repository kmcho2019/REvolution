module TopModule(output one);
    localparam logic CONST_ONE = 1'b1;  // Fixed named constant for clarity and maintainability
    assign one = CONST_ONE;              // Continuous assignment from named constant
endmodule