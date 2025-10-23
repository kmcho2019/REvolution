module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Unpack 'in' into 256 4-bit elements
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_unpack
            assign in_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Stage 1: For each of 16 groups, 16-to-1 mux using sel[3:0]
    wire [3:0] stage1_out [0:15];
    genvar g;
    generate
        for (g = 0; g < 16; g = g + 1) begin : stage1_mux
            // Multiplex 16 inputs: in_array[g*16 + 0 .. g*16 + 15]
            // Use a case statement for clean selection
            reg [3:0] mux_out;
            always @(*) begin
                case (sel[3:0])
                    4'd0:  mux_out = in_array[g*16 + 0];
                    4'd1:  mux_out = in_array[g*16 + 1];
                    4'd2:  mux_out = in_array[g*16 + 2];
                    4'd3:  mux_out = in_array[g*16 + 3];
                    4'd4:  mux_out = in_array[g*16 + 4];
                    4'd5:  mux_out = in_array[g*16 + 5];
                    4'd6:  mux_out = in_array[g*16 + 6];
                    4'd7:  mux_out = in_array[g*16 + 7];
                    4'd8:  mux_out = in_array[g*16 + 8];
                    4'd9:  mux_out = in_array[g*16 + 9];
                    4'd10: mux_out = in_array[g*16 + 10];
                    4'd11: mux_out = in_array[g*16 + 11];
                    4'd12: mux_out = in_array[g*16 + 12];
                    4'd13: mux_out = in_array[g*16 + 13];
                    4'd14: mux_out = in_array[g*16 + 14];
                    4'd15: mux_out = in_array[g*16 + 15];
                    default: mux_out = 4'b0;
                endcase
            end
            assign stage1_out[g] = mux_out;
        end
    endgenerate

    // Stage 2: 16-to-1 mux selecting one 4-bit output from stage1_out using sel[7:4]
    reg [3:0] out_reg;
    always @(*) begin
        case (sel[7:4])
            4'd0:  out_reg = stage1_out[0];
            4'd1:  out_reg = stage1_out[1];
            4'd2:  out_reg = stage1_out[2];
            4'd3:  out_reg = stage1_out[3];
            4'd4:  out_reg = stage1_out[4];
            4'd5:  out_reg = stage1_out[5];
            4'd6:  out_reg = stage1_out[6];
            4'd7:  out_reg = stage1_out[7];
            4'd8:  out_reg = stage1_out[8];
            4'd9:  out_reg = stage1_out[9];
            4'd10: out_reg = stage1_out[10];
            4'd11: out_reg = stage1_out[11];
            4'd12: out_reg = stage1_out[12];
            4'd13: out_reg = stage1_out[13];
            4'd14: out_reg = stage1_out[14];
            4'd15: out_reg = stage1_out[15];
            default: out_reg = 4'b0;
        endcase
    end

    assign out = out_reg;

endmodule