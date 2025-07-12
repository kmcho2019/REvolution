module TopModule (
    input x,
    input y,
    output z
);
    // Alternative equally efficient implementation
    assign z = x ~^ y;  // XNOR operation (alternative syntax)
endmodule