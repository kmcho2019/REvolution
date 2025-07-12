module TopModule(
    output zero
);
    // Directly assign the output to a constant LOW for optimal PPA metrics
    assign zero = 1'b0;
endmodule