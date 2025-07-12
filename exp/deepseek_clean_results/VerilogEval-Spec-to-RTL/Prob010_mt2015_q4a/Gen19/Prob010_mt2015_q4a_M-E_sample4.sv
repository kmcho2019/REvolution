module TopModule (
    input x,
    input y,
    output z
);
    // MUX-based implementation
    assign z = y ? 1'b0 : x;
endmodule