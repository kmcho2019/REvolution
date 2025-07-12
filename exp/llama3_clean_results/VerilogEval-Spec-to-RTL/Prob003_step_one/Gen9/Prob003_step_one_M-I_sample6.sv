// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Directly connect output 'one' to VDD (logic high) using a wire.
wire one = 1'b1;

endmodule