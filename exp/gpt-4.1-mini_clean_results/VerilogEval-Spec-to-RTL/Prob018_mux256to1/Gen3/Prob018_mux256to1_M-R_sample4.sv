module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output reg     out
);
    reg [15:0] level1_out;
    integer i;

    // Combinational logic for 16 16-to-1 muxes
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            case (sel[3:0])
                4'd0:  level1_out[i] = in[i*16 + 0];
                4'd1:  level1_out[i] = in[i*16 + 1];
                4'd2:  level1_out[i] = in[i*16 + 2];
                4'd3:  level1_out[i] = in[i*16 + 3];
                4'd4:  level1_out[i] = in[i*16 + 4];
                4'd5:  level1_out[i] = in[i*16 + 5];
                4'd6:  level1_out[i] = in[i*16 + 6];
                4'd7:  level1_out[i] = in[i*16 + 7];
                4'd8:  level1_out[i] = in[i*16 + 8];
                4'd9:  level1_out[i] = in[i*16 + 9];
                4'd10: level1_out[i] = in[i*16 + 10];
                4'd11: level1_out[i] = in[i*16 + 11];
                4'd12: level1_out[i] = in[i*16 + 12];
                4'd13: level1_out[i] = in[i*16 + 13];
                4'd14: level1_out[i] = in[i*16 + 14];
                4'd15: level1_out[i] = in[i*16 + 15];
                default: level1_out[i] = 1'b0;
            endcase
        end
    end

    // Final 16-to-1 mux selecting the output bit from level1_out
    always @(*) begin
        case (sel[7:4])
            4'd0:  out = level1_out[0];
            4'd1:  out = level1_out[1];
            4'd2:  out = level1_out[2];
            4'd3:  out = level1_out[3];
            4'd4:  out = level1_out[4];
            4'd5:  out = level1_out[5];
            4'd6:  out = level1_out[6];
            4'd7:  out = level1_out[7];
            4'd8:  out = level1_out[8];
            4'd9:  out = level1_out[9];
            4'd10: out = level1_out[10];
            4'd11: out = level1_out[11];
            4'd12: out = level1_out[12];
            4'd13: out = level1_out[13];
            4'd14: out = level1_out[14];
            4'd15: out = level1_out[15];
            default: out = 1'b0;
        endcase
    end

endmodule