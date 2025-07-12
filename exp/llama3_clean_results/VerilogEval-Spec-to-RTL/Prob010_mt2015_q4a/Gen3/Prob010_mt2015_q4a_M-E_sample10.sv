module TopModule(
    input x,
    input y,
    output z
);

assign z = (y)? 0 : x;

endmodule