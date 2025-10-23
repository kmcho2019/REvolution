module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0
    assign out_any  = {in[3:1] | in[2:0], 1'b0};

    // out_different[i] = in[i] ^ in[(i+1) mod 4]; wrap-around handled explicitly
    wire [2:0] out_diff_lower;
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_diff
            assign out_diff_lower[i] = in[i] ^ in[i+1];
        end
    endgenerate
    assign out_different = {in[3] ^ in[0], out_diff_lower};

endmodule