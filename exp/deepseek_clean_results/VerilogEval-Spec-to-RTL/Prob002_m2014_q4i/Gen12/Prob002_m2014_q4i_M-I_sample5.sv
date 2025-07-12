module TopModule (
    output out
);
    // Direct assignment remains the optimal solution
    // Using (supply0) for explicit ground connection if supported
    assign (supply0, pull0) out = 1'b0;
endmodule