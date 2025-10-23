module TopModule(
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    wire [31:0] stage1_out; // outputs from 32 first-stage 8-to-1 muxes

    // Lower 3 bits for selecting within each group of 8
    wire [2:0] sel_low = sel[2:0];
    // Upper 5 bits for selecting among the 32 groups
    wire [4:0] sel_high = sel[7:3];

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : mux8to1_stage1
            wire [7:0] group = in[i*8 +: 8];
            // 8-to-1 mux using a case statement to guide synthesis efficiently
            reg mux_out;
            always @(*) begin
                case (sel_low)
                    3'd0: mux_out = group[0];
                    3'd1: mux_out = group[1];
                    3'd2: mux_out = group[2];
                    3'd3: mux_out = group[3];
                    3'd4: mux_out = group[4];
                    3'd5: mux_out = group[5];
                    3'd6: mux_out = group[6];
                    3'd7: mux_out = group[7];
                    default: mux_out = 1'b0; // default safe value
                endcase
            end
            assign stage1_out[i] = mux_out;
        end
    endgenerate

    // Second stage: 32-to-1 mux selected by sel_high (5 bits)
    reg out_reg;
    always @(*) begin
        case (sel_high)
            5'd0 : out_reg = stage1_out[0];
            5'd1 : out_reg = stage1_out[1];
            5'd2 : out_reg = stage1_out[2];
            5'd3 : out_reg = stage1_out[3];
            5'd4 : out_reg = stage1_out[4];
            5'd5 : out_reg = stage1_out[5];
            5'd6 : out_reg = stage1_out[6];
            5'd7 : out_reg = stage1_out[7];
            5'd8 : out_reg = stage1_out[8];
            5'd9 : out_reg = stage1_out[9];
            5'd10: out_reg = stage1_out[10];
            5'd11: out_reg = stage1_out[11];
            5'd12: out_reg = stage1_out[12];
            5'd13: out_reg = stage1_out[13];
            5'd14: out_reg = stage1_out[14];
            5'd15: out_reg = stage1_out[15];
            5'd16: out_reg = stage1_out[16];
            5'd17: out_reg = stage1_out[17];
            5'd18: out_reg = stage1_out[18];
            5'd19: out_reg = stage1_out[19];
            5'd20: out_reg = stage1_out[20];
            5'd21: out_reg = stage1_out[21];
            5'd22: out_reg = stage1_out[22];
            5'd23: out_reg = stage1_out[23];
            5'd24: out_reg = stage1_out[24];
            5'd25: out_reg = stage1_out[25];
            5'd26: out_reg = stage1_out[26];
            5'd27: out_reg = stage1_out[27];
            5'd28: out_reg = stage1_out[28];
            5'd29: out_reg = stage1_out[29];
            5'd30: out_reg = stage1_out[30];
            5'd31: out_reg = stage1_out[31];
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;

endmodule