module TopModule (
    output one = 1'b1
);
    localparam CONST_ONE = 1'b1;
    // Output is directly tied to constant high
    // Using both direct assignment and named constant for documentation
endmodule