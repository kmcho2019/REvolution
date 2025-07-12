module TopModule #(
    parameter FLAT = 0 // 0: hierarchical with case statements; 1: flat direct indexing
)(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output reg          out
);

    // Intermediate level0 outputs: 16 bits each selected from 16-bit slices using sel[3:0]
    reg [15:0] level0_out;

    integer i;
    always @(*) begin
        if (FLAT) begin
            // Flat direct indexing
            out = in[sel];
        end else begin
            // Level 0: select 1 bit from each 16-bit slice of 'in' based on sel[3:0]
            for (i = 0; i < 16; i = i + 1) begin
                case (sel[3:0])
                    4'd0:  level0_out[i] = in[i*16 + 0];
                    4'd1:  level0_out[i] = in[i*16 + 1];
                    4'd2:  level0_out[i] = in[i*16 + 2];
                    4'd3:  level0_out[i] = in[i*16 + 3];
                    4'd4:  level0_out[i] = in[i*16 + 4];
                    4'd5:  level0_out[i] = in[i*16 + 5];
                    4'd6:  level0_out[i] = in[i*16 + 6];
                    4'd7:  level0_out[i] = in[i*16 + 7];
                    4'd8:  level0_out[i] = in[i*16 + 8];
                    4'd9:  level0_out[i] = in[i*16 + 9];
                    4'd10: level0_out[i] = in[i*16 + 10];
                    4'd11: level0_out[i] = in[i*16 + 11];
                    4'd12: level0_out[i] = in[i*16 + 12];
                    4'd13: level0_out[i] = in[i*16 + 13];
                    4'd14: level0_out[i] = in[i*16 + 14];
                    4'd15: level0_out[i] = in[i*16 + 15];
                    default: level0_out[i] = 1'bx;
                endcase
            end

            // Level 1: select 1 bit from the 16 bits selected above using sel[7:4]
            case (sel[7:4])
                4'd0:  out = level0_out[0];
                4'd1:  out = level0_out[1];
                4'd2:  out = level0_out[2];
                4'd3:  out = level0_out[3];
                4'd4:  out = level0_out[4];
                4'd5:  out = level0_out[5];
                4'd6:  out = level0_out[6];
                4'd7:  out = level0_out[7];
                4'd8:  out = level0_out[8];
                4'd9:  out = level0_out[9];
                4'd10: out = level0_out[10];
                4'd11: out = level0_out[11];
                4'd12: out = level0_out[12];
                4'd13: out = level0_out[13];
                4'd14: out = level0_out[14];
                4'd15: out = level0_out[15];
                default: out = 1'bx;
            endcase
        end
    end
endmodule