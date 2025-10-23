// TopModule: An optimized module that drives its output high.
module TopModule(
    output one
);
    // Directly assign 1 to the output port, which is already optimized.
    assign one = 1'b1;
endmodule