module TopModule (
    input x,
    input y,
    output z
);
    // Direct implementation of z = x & ~y
    // More efficient than mux approach as it requires only one logical operation
    // when the library has an AND-NOT compound gate
    assign z = x & ~y;
endmodule