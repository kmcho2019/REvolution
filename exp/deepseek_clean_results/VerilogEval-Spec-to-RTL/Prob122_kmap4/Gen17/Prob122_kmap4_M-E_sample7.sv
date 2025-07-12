module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // 2D parity check implementation
    wire row_parity = c ^ d;
    wire col_parity = a ^ b;
    
    assign out = ~(row_parity ^ col_parity);

endmodule