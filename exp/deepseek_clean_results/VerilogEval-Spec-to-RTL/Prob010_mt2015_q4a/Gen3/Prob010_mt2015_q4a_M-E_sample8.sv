module TopModule (
    input x,
    input y,
    output z
);
    // Implement as a 2:1 MUX
    assign z = x ? ~y : 1'b0;
endmodule