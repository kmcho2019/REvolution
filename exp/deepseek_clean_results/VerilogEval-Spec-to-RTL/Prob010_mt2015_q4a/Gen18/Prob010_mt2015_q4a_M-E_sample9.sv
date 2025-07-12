module TopModule (
    input x,
    input y,
    output z
);
    // Mux-based implementation
    assign z = x ? ~y : 1'b0;
endmodule