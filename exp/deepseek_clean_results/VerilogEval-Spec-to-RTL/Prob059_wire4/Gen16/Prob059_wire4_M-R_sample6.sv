module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Explicit wire declarations
    wire w_conn, x_conn, y_conn, z_conn;
    
    // Continuous assignments
    assign w_conn = a;
    assign x_conn = b;
    assign y_conn = b;
    assign z_conn = c;
    
    // Output assignments
    assign w = w_conn;
    assign x = x_conn;
    assign y = y_conn;
    assign z = z_conn;
endmodule