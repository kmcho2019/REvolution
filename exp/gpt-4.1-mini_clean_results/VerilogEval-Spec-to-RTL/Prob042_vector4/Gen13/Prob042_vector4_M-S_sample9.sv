module TopModule (
    input  [7:0] in,
    output signed [31:0] out
);

    assign out = $signed(in);

endmodule