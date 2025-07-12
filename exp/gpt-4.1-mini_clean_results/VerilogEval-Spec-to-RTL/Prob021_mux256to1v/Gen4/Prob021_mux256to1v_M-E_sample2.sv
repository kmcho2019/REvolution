module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Split input into 64 blocks of 16 bits (4 words * 4 bits)
    wire [15:0] block [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            assign block[i] = in[16*i +: 16];
        end
    endgenerate

    // Select one 16-bit block using upper 6 bits of sel
    wire [15:0] selected_block;
    reg  [15:0] block_reg;
    always @(*) begin
        case(sel[7:2])
            6'd0  : block_reg = block[0];
            6'd1  : block_reg = block[1];
            6'd2  : block_reg = block[2];
            6'd3  : block_reg = block[3];
            6'd4  : block_reg = block[4];
            6'd5  : block_reg = block[5];
            6'd6  : block_reg = block[6];
            6'd7  : block_reg = block[7];
            6'd8  : block_reg = block[8];
            6'd9  : block_reg = block[9];
            6'd10 : block_reg = block[10];
            6'd11 : block_reg = block[11];
            6'd12 : block_reg = block[12];
            6'd13 : block_reg = block[13];
            6'd14 : block_reg = block[14];
            6'd15 : block_reg = block[15];
            6'd16 : block_reg = block[16];
            6'd17 : block_reg = block[17];
            6'd18 : block_reg = block[18];
            6'd19 : block_reg = block[19];
            6'd20 : block_reg = block[20];
            6'd21 : block_reg = block[21];
            6'd22 : block_reg = block[22];
            6'd23 : block_reg = block[23];
            6'd24 : block_reg = block[24];
            6'd25 : block_reg = block[25];
            6'd26 : block_reg = block[26];
            6'd27 : block_reg = block[27];
            6'd28 : block_reg = block[28];
            6'd29 : block_reg = block[29];
            6'd30 : block_reg = block[30];
            6'd31 : block_reg = block[31];
            6'd32 : block_reg = block[32];
            6'd33 : block_reg = block[33];
            6'd34 : block_reg = block[34];
            6'd35 : block_reg = block[35];
            6'd36 : block_reg = block[36];
            6'd37 : block_reg = block[37];
            6'd38 : block_reg = block[38];
            6'd39 : block_reg = block[39];
            6'd40 : block_reg = block[40];
            6'd41 : block_reg = block[41];
            6'd42 : block_reg = block[42];
            6'd43 : block_reg = block[43];
            6'd44 : block_reg = block[44];
            6'd45 : block_reg = block[45];
            6'd46 : block_reg = block[46];
            6'd47 : block_reg = block[47];
            6'd48 : block_reg = block[48];
            6'd49 : block_reg = block[49];
            6'd50 : block_reg = block[50];
            6'd51 : block_reg = block[51];
            6'd52 : block_reg = block[52];
            6'd53 : block_reg = block[53];
            6'd54 : block_reg = block[54];
            6'd55 : block_reg = block[55];
            6'd56 : block_reg = block[56];
            6'd57 : block_reg = block[57];
            6'd58 : block_reg = block[58];
            6'd59 : block_reg = block[59];
            6'd60 : block_reg = block[60];
            6'd61 : block_reg = block[61];
            6'd62 : block_reg = block[62];
            6'd63 : block_reg = block[63];
            default: block_reg = 16'd0;
        endcase
    end

    // Then select 4 bits inside the 16-bit block based on lower 2 bits of sel
    // 4 possible 4-bit words at bits [3:0], [7:4], [11:8], [15:12]
    wire [3:0] selected_word;
    assign selected_word = (sel[1:0] == 2'd0) ? block_reg[3:0]   :
                           (sel[1:0] == 2'd1) ? block_reg[7:4]   :
                           (sel[1:0] == 2'd2) ? block_reg[11:8]  :
                                                block_reg[15:12];

    assign out = selected_word;

endmodule