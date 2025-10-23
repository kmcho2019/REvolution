module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    wire and1 = p1a & p1b & p1c;
    wire and2 = p1d & p1e & p1f;
    wire and3 = p2a & p2b;
    wire and4 = p2c & p2d;
    
    assign p1y = and1 | and2;
    assign p2y = and3 | and4;
endmodule