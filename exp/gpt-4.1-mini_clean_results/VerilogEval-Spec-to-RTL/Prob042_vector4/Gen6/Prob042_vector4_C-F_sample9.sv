module TopModule (
    input  [7:0] in,
    output signed [31:0] out
);

    localparam int SIGN_EXTEND_BITS = 24;

    assign out = {{SIGN_EXTEND_BITS{in[7]}}, in};

endmodule