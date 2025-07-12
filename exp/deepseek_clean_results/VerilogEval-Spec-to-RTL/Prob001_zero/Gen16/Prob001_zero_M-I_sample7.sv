module TopModule (
    output zero
);
    // Optimal implementation - direct constant LOW assignment
    // Provides zero-delay output with minimal power and area
    assign zero = 1'b0;
endmodule