module TopModule(
    input  in,
    output out
);

    // Internal wire for MUX selection
    wire sel;

    // Always select the first input
    assign sel = 1'b0;

    // 1-to-1 MUX implementation
    assign out = (sel) ? 1'b0 : in;

endmodule