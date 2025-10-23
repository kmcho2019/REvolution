module TopModule (
    input x,
    input y,
    output z
);
    wire y_not;  // Intermediate signal for inverted y
    
    // Gate-level implementation
    not(y_not, y);
    and(z, x, y_not);
endmodule