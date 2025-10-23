module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    localparam SIGN_EXTENSION_BITS = 24;
    assign out = {{SIGN_EXTENSION_BITS{in[7]}}, in};
endmodule