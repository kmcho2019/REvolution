module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Alternative implementation using equality operator
endmodule