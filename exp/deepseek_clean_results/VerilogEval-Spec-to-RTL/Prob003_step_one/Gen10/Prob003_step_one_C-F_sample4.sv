module TopModule (
    output one
);
    // Direct assignment to constant logic high
    // Most efficient implementation with zero propagation delay
    assign one = 1'b1;
endmodule