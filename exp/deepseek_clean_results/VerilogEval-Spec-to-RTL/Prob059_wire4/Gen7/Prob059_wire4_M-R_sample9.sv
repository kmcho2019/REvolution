module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    wire b_connections;
    assign b_connections = b;
    
    assign w = a;
    assign x = b_connections;
    assign y = b_connections;
    assign z = c;
endmodule