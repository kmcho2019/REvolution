module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding - 2-bit binary
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3,
        E = 2'd4, // Can't encode 4 with 2 bits, so must keep 3 bits actually
        F = 2'd5; // Same issue

endmodule