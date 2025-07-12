module TopModule (
    output zero
);
    // Conceptually equivalent to: zero = 1'b0 & anything
    // But implemented directly for optimal PPA
    assign zero = 1'b0;
endmodule