// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);
    // Directly assign the value 1 to the output port to always drive logic high
    assign one = 1'b1;
endmodule