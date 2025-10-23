module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);
    // First stage: 16x 16:1 muxes (4-bit each)
    wire [63:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            wire [3:0] mux_in [0:15];
            integer j;
            for (j = 0; j < 16; j = j + 1) begin
                assign mux_in[j] = in[(i*64 + j*4) +: 4];
            end
            assign stage1_out[(i*4)+:4] = mux_in[sel[3:0]];
        end
    endgenerate

    // Second stage: 1x 16:1 mux
    wire [3:0] stage2_in [0:15];
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : stage2
            assign stage2_in[k] = stage1_out[(k*4)+:4];
        end
    endgenerate

    // Registered output
    always @(*) begin
        out = stage2_in[sel[7:4]];
    end
endmodule