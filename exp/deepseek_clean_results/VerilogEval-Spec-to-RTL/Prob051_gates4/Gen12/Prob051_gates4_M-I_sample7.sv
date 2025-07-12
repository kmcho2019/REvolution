module TopModule(
    input  wire [3:0] in,
    input  wire       enable,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    assign out_and = enable & (&in);
    assign out_or  = enable & (|in);
    assign out_xor = enable & (^in);

endmodule