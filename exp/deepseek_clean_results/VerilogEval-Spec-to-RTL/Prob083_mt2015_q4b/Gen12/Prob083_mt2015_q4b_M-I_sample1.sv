module TopModule (
    input x,
    input y,
    output z
);
    wire x_n, y_n;
    wire and1, and2;
    
    assign x_n = ~x;
    assign y_n = ~y;
    assign and1 = x & y;
    assign and2 = x_n & y_n;
    assign z = and1 | and2;
endmodule