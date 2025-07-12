module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

always @(in) begin
    // Initialize output vectors
    out_both = 4'b0000;
    out_any = 4'b0000;
    out_different = 4'b0000;

    // Calculate out_both
    out_both[2] = in[2] & in[3];
    out_both[1] = in[1] & in[2];
    out_both[0] = in[0] & in[1];

    // Calculate out_any
    out_any[3] = in[3] | in[2];
    out_any[2] = in[2] | in[1];
    out_any[1] = in[1] | in[0];

    // Calculate out_different
    out_different[3] = in[3] ^ in[0]; // Wrap-around for most significant bit
    out_different[2] = in[2] ^ in[3];
    out_different[1] = in[1] ^ in[2];
    out_different[0] = in[0] ^ in[1];
end

endmodule