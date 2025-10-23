module TopModule (
    output zero
);
    // Optimal implementation - direct constant assignment to ground
    assign zero = 1'b0;  // Synthesizes to a direct ground connection
endmodule