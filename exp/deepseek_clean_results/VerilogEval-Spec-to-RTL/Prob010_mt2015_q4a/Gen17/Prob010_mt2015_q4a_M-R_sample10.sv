module TopModule (
    input x,
    input y,
    output z
);
    wire not_y;
    
    // Explicit gate-level implementation
    not inv1(not_y, y);
    and and1(z, x, not_y);
endmodule