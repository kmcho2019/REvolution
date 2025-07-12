module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 32 groups of 8 bits
    wire [7:0] group [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign group[i] = in[(i*8)+7:(i*8)];
        end
    endgenerate

    // Select one of the 32 groups using the most significant 5 bits of the select signal
    wire [7:0] stage1_out [7:0];
    wire [4:0] stage1_sel = sel[7:3];
    genvar j;
    generate
        for (j = 0; j < 8; j++) begin
            assign stage1_out[j] = group[j + (stage1_sel * 8)];
        end
    endgenerate

    // Select one of the 8 bits within the chosen group using the next 3 bits of the select signal
    wire stage2_out;
    wire [2:0] stage2_sel = sel[2:0];
    always @(*)
    begin
        case (stage2_sel)
            3'b000: stage2_out = stage1_out[0][0];
            3'b001: stage2_out = stage1_out[0][1];
            3'b010: stage2_out = stage1_out[0][2];
            3'b011: stage2_out = stage1_out[0][3];
            3'b100: stage2_out = stage1_out[0][4];
            3'b101: stage2_out = stage1_out[0][5];
            3'b110: stage2_out = stage1_out[0][6];
            3'b111: stage2_out = stage1_out[0][7];
            default: stage2_out = 1'b0;
        endcase
    end

    assign out = stage2_out;

endmodule