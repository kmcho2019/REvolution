module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output out // 1-bit output
);

    // Level 1: 64 4-to-1 multiplexers
    wire [63:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin
            mux4to1 mux4to1_inst (
               .in({in[(i*4)+3], in[(i*4)+2], in[(i*4)+1], in[i*4]}),
               .sel(sel[1:0]),
               .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 16 4-to-1 multiplexers
    wire [15:0] level2_out;
    generate
        for (i = 0; i < 16; i++) begin
            mux4to1 mux4to1_inst (
               .in({level1_out[(i*4)+3], level1_out[(i*4)+2], level1_out[(i*4)+1], level1_out[i*4]}),
               .sel(sel[3:2]),
               .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: 4 4-to-1 multiplexers
    wire [3:0] level3_out;
    generate
        for (i = 0; i < 4; i++) begin
            mux4to1 mux4to1_inst (
               .in({level2_out[(i*4)+3], level2_out[(i*4)+2], level2_out[(i*4)+1], level2_out[i*4]}),
               .sel(sel[5:4]),
               .out(level3_out[i])
            );
        end
    endgenerate

    // Level 4: 1 4-to-1 multiplexer
    wire [0:0] level4_out;
    mux4to1 mux4to1_inst (
       .in({level3_out[3], level3_out[2], level3_out[1], level3_out[0]}),
       .sel(sel[7:6]),
       .out(level4_out[0])
    );

    assign out = level4_out[0];

endmodule

module mux4to1(
    input [3:0] in,
    input [1:0] sel,
    output out
);

    always @(*) begin
        case (sel)
            2'd0: out = in[0];
            2'd1: out = in[1];
            2'd2: out = in[2];
            2'd3: out = in[3];
            default: out = 1'b0;
        endcase
    end

endmodule