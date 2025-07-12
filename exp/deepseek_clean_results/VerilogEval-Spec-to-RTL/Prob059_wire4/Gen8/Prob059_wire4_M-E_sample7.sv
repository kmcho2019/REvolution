module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Implement each connection as two NOT gates in series (buffer)
    not(w_not, a);
    not(w, w_not);
    
    not(x_not1, b);
    not(x, x_not1);
    
    not(y_not1, b);
    not(y, y_not1);
    
    not(z_not, c);
    not(z, z_not);
endmodule