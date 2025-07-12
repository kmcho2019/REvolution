module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

always_comb begin
    out_and = in[0] & in[1] & in[2] & in[3];
    out_or  = in[0] | in[1] | in[2] | in[3];
    out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
end

endmodule