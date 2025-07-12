module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;

    // out_both: bits 0..2 assigned in[i] & in[i+1], out_both[3] = 0 explicitly
    assign out_both[3] = 1'b0;
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any: bits 1..3 assigned in[i] | in[i-1], out_any[0] = 0 explicitly
    assign out_any[0] = 1'b0;
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different: wrap-around neighbor at (i+1)%4 using localparam
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_different
            localparam int left_neighbor = (i + 1) % 4;
            assign out_different[i] = in[i] ^ in[left_neighbor];
        end
    endgenerate

endmodule