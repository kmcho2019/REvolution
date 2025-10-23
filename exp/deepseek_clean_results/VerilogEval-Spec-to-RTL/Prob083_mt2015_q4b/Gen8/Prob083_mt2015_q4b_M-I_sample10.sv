module TopModule (
    input x,
    input y,
    output z
);
    wire z;
    assign z = ~(x ^ y);
endmodule