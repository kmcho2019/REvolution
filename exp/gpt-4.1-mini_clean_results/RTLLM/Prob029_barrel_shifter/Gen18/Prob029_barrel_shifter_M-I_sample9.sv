// 2-to-1 multiplexer module with a unique name to avoid conflicts
module barrel_mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Helper function for modular indexing (mod 8)
    function integer mod8;
        input integer idx;
        begin
            mod8 = idx & 3'b111;  // index mod 8
        end
    endfunction

    // Stage 0: shift by 4 if ctrl[2] == 1
    wire [7:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage0
            // Rotate left by 4: output bit i selects in[i] or in[(i+4) mod 8]
            barrel_mux2X1 mux_inst (
                .d0(in[i]),
                .d1(in[mod8(i + 4)]),
                .sel(ctrl[2]),
                .y(stage0[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 if ctrl[1] == 1
    wire [7:0] stage1;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1
            // Rotate left by 2: output bit i selects stage0[i] or stage0[(i+2) mod 8]
            barrel_mux2X1 mux_inst (
                .d0(stage0[i]),
                .d1(stage0[mod8(i + 2)]),
                .sel(ctrl[1]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage2
            // Rotate left by 1: output bit i selects stage1[i] or stage1[(i+1) mod 8]
            barrel_mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(stage1[mod8(i + 1)]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule