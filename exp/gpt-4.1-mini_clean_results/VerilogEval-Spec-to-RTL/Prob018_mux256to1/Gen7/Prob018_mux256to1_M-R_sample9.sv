module Mux16to1 (
    input  [15:0] in,
    input  [3:0]  sel,
    output reg    out
);
    always @(*) begin
        case (sel)
            4'd0:  out = in[0];
            4'd1:  out = in[1];
            4'd2:  out = in[2];
            4'd3:  out = in[3];
            4'd4:  out = in[4];
            4'd5:  out = in[5];
            4'd6:  out = in[6];
            4'd7:  out = in[7];
            4'd8:  out = in[8];
            4'd9:  out = in[9];
            4'd10: out = in[10];
            4'd11: out = in[11];
            4'd12: out = in[12];
            4'd13: out = in[13];
            4'd14: out = in[14];
            4'd15: out = in[15];
            default: out = 1'b0;
        endcase
    end
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output reg     out
);
    wire [15:0] level1_out;
    integer i;

    // Intermediate outputs from 16-to-1 muxes
    // We instantiate 16 Mux16to1 modules and collect their outputs in level1_out.
    genvar idx;
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : LEVEL1_MUXES
            Mux16to1 u_mux16 (
                .in(in[idx*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[idx])
            );
        end
    endgenerate

    // Final 16-to-1 mux implemented in procedural block using case statement
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