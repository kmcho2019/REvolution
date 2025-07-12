module TopModule (
    input x,
    input y,
    output z
);
    // Direct implementation using XOR and AND
    assign z = (x ^ y) & x;
endmodule