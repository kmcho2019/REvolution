module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output reg          out
);

    wire [15:0] level1_outputs;
    wire [3:0] lower_sel = sel[3:0];
    wire [3:0] upper_sel = sel[7:4];
    
    // First level: 16 muxes each selecting 1 bit out of 16 bits in their group
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            reg mux16_out;
            always @(*) begin
                case(lower_sel)
                    4'd0 : mux16_out = in[i*16 + 0];
                    4'd1 : mux16_out = in[i*16 + 1];
                    4'd2 : mux16_out = in[i*16 + 2];
                    4'd3 : mux16_out = in[i*16 + 3];
                    4'd4 : mux16_out = in[i*16 + 4];
                    4'd5 : mux16_out = in[i*16 + 5];
                    4'd6 : mux16_out = in[i*16 + 6];
                    4'd7 : mux16_out = in[i*16 + 7];
                    4'd8 : mux16_out = in[i*16 + 8];
                    4'd9 : mux16_out = in[i*16 + 9];
                    4'd10: mux16_out = in[i*16 + 10];
                    4'd11: mux16_out = in[i*16 + 11];
                    4'd12: mux16_out = in[i*16 + 12];
                    4'd13: mux16_out = in[i*16 + 13];
                    4'd14: mux16_out = in[i*16 + 14];
                    4'd15: mux16_out = in[i*16 + 15];
                    default: mux16_out = 1'b0;
                endcase
            end
            assign level1_outputs[i] = mux16_out;
        end
    endgenerate

    // Second level: 16-to-1 mux selecting among the 16 outputs from first level
    always @(*) begin
        case(upper_sel)
            4'd0 : out = level1_outputs[0];
            4'd1 : out = level1_outputs[1];
            4'd2 : out = level1_outputs[2];
            4'd3 : out = level1_outputs[3];
            4'd4 : out = level1_outputs[4];
            4'd5 : out = level1_outputs[5];
            4'd6 : out = level1_outputs[6];
            4'd7 : out = level1_outputs[7];
            4'd8 : out = level1_outputs[8];
            4'd9 : out = level1_outputs[9];
            4'd10: out = level1_outputs[10];
            4'd11: out = level1_outputs[11];
            4'd12: out = level1_outputs[12];
            4'd13: out = level1_outputs[13];
            4'd14: out = level1_outputs[14];
            4'd15: out = level1_outputs[15];
            default: out = 1'b0;
        endcase
    end

endmodule