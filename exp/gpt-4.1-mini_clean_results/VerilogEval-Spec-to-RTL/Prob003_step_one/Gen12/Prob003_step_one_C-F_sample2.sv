module TopModule(output one);
    parameter logic CONST_ONE = 1'b1;  // Named constant, allows potential override
    assign one = CONST_ONE;             // Continuous assignment to output
endmodule