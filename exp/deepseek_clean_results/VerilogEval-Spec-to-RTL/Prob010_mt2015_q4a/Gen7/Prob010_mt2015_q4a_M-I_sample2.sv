module TopModule (
    input x,
    input y,
    output z
);
    // Maintain original optimal implementation
    assign z = x & ~y;
    
    // Alternative implementation that might be better in some technologies:
    // wire temp;
    // nand(temp, x, y);
    // not(z, temp);
endmodule