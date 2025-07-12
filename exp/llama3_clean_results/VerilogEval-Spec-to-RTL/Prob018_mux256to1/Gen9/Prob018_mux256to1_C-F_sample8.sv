module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output reg out
);

    always @(*) begin
        case (sel[7:4]) // Select which group
            4'd0: out = in[sel[3:0]];
            4'd1: out = in[16 + sel[3:0]];
            4'd2: out = in[32 + sel[3:0]];
            4'd3: out = in[48 + sel[3:0]];
            4'd4: out = in[64 + sel[3:0]];
            4'd5: out = in[80 + sel[3:0]];
            4'd6: out = in[96 + sel[3:0]];
            4'd7: out = in[112 + sel[3:0]];
            4'd8: out = in[128 + sel[3:0]];
            4'd9: out = in[144 + sel[3:0]];
            4'd10: out = in[160 + sel[3:0]];
            4'd11: out = in[176 + sel[3:0]];
            4'd12: out = in[192 + sel[3:0]];
            4'd13: out = in[208 + sel[3:0]];
            4'd14: out = in[224 + sel[3:0]];
            4'd15: out = in[240 + sel[3:0]];
            default: out = 1'b0; // default value
        endcase
    end

endmodule