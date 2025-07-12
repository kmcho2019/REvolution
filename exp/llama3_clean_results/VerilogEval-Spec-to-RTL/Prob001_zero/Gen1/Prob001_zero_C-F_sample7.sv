// TopModule with a single output port 'zero' that always outputs a LOW
module TopModule(
    output zero
);
    // Directly assign the output 'zero' to a constant low value (1'b0)
    assign zero = 1'b0;

endmodule