module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    wire [3:0] level1_out [0:15]; // Outputs of 16 blocks, each 16-to-1 mux

    genvar blk, idx;

    // Implement 16 blocks of 16-to-1 muxes (select lower 4 bits of sel)
    generate
        for (blk = 0; blk < 16; blk = blk + 1) begin : blocks_16to1
            wire [3:0] block_inputs [0:15];
            for (idx = 0; idx < 16; idx = idx + 1) begin : inputs_in_block
                // Each input is 4 bits
                // Overall index = blk*16 + idx
                assign block_inputs[idx] = in[4*(blk*16 + idx) +: 4];
            end

            // 16-to-1 mux for this block using lower 4 bits of sel
            reg [3:0] block_out_reg;
            integer k;
            always @(*) begin
                block_out_reg = 4'b0;
                case (sel[3:0])
                    4'd0:  block_out_reg = block_inputs[0];
                    4'd1:  block_out_reg = block_inputs[1];
                    4'd2:  block_out_reg = block_inputs[2];
                    4'd3:  block_out_reg = block_inputs[3];
                    4'd4:  block_out_reg = block_inputs[4];
                    4'd5:  block_out_reg = block_inputs[5];
                    4'd6:  block_out_reg = block_inputs[6];
                    4'd7:  block_out_reg = block_inputs[7];
                    4'd8:  block_out_reg = block_inputs[8];
                    4'd9:  block_out_reg = block_inputs[9];
                    4'd10: block_out_reg = block_inputs[10];
                    4'd11: block_out_reg = block_inputs[11];
                    4'd12: block_out_reg = block_inputs[12];
                    4'd13: block_out_reg = block_inputs[13];
                    4'd14: block_out_reg = block_inputs[14];
                    4'd15: block_out_reg = block_inputs[15];
                    default: block_out_reg = 4'b0;
                endcase
            end

            assign level1_out[blk] = block_out_reg;
        end
    endgenerate

    // Final 16-to-1 mux selecting among level1_out using higher 4 bits of sel
    reg [3:0] out_reg;
    always @(*) begin
        case (sel[7:4])
            4'd0:  out_reg = level1_out[0];
            4'd1:  out_reg = level1_out[1];
            4'd2:  out_reg = level1_out[2];
            4'd3:  out_reg = level1_out[3];
            4'd4:  out_reg = level1_out[4];
            4'd5:  out_reg = level1_out[5];
            4'd6:  out_reg = level1_out[6];
            4'd7:  out_reg = level1_out[7];
            4'd8:  out_reg = level1_out[8];
            4'd9:  out_reg = level1_out[9];
            4'd10: out_reg = level1_out[10];
            4'd11: out_reg = level1_out[11];
            4'd12: out_reg = level1_out[12];
            4'd13: out_reg = level1_out[13];
            4'd14: out_reg = level1_out[14];
            4'd15: out_reg = level1_out[15];
            default: out_reg = 4'b0;
        endcase
    end

    assign out = out_reg;

endmodule