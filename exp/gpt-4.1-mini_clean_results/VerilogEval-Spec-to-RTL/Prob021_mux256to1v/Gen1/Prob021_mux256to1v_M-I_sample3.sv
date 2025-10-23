module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    wire [3:0] stage1_out; // output after first-level mux (16:1)
    wire [3:0] stage2_out; // output after second-level mux (16:1)

    // First-level select: select one 4-bit slice among 16 entries (16*4=64 bits)
    wire [63:0] group = in[(sel[7:4]*64) +: 64];

    // First-level mux: select 4-bit word among 16 in the selected group, based on sel[3:0]
    reg [3:0] stage1;
    always @(*) begin
        case (sel[3:0])
            4'd0:  stage1 = group[3:0];
            4'd1:  stage1 = group[7:4];
            4'd2:  stage1 = group[11:8];
            4'd3:  stage1 = group[15:12];
            4'd4:  stage1 = group[19:16];
            4'd5:  stage1 = group[23:20];
            4'd6:  stage1 = group[27:24];
            4'd7:  stage1 = group[31:28];
            4'd8:  stage1 = group[35:32];
            4'd9:  stage1 = group[39:36];
            4'd10: stage1 = group[43:40];
            4'd11: stage1 = group[47:44];
            4'd12: stage1 = group[51:48];
            4'd13: stage1 = group[55:52];
            4'd14: stage1 = group[59:56];
            4'd15: stage1 = group[63:60];
            default: stage1 = 4'b0;
        endcase
    end

    assign out = stage1;

endmodule