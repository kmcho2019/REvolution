// TopModule: Always drives output 'one' high, refactored using an initial block.
module TopModule(
    output reg one
);

// Use an initial block to set the output 'one' high.
initial one = 1'b1;

endmodule