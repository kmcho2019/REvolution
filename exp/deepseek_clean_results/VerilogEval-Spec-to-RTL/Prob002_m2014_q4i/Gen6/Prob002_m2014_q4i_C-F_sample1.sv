module TopModule (
    output out
);
    // Optimal implementation - direct continuous assignment to 0
    // Provides minimal power, area, and zero timing paths
    assign out = 1'b0;
endmodule