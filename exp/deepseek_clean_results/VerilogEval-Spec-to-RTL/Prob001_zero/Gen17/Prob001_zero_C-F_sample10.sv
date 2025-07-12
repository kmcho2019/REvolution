module TopModule (
    output zero
);
    // Optimal constant LOW output implementation
    // Zero timing paths, minimal power, smallest possible area
    assign zero = 1'b0;
endmodule