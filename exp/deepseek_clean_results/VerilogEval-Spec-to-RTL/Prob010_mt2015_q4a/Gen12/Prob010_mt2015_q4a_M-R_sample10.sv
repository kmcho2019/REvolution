module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) ? x : 1'b0;
endmodule