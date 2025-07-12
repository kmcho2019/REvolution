module TopModule (
    input x,
    input y,
    output z
);
    // MUX implementation
    assign z = x ? ~y : 1'b0;
endmodule