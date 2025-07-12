module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    reg [7:0] out_hi_reg;
    reg [7:0] out_lo_reg;

    always @(*) begin
        case (in[15:8])
            16'h00: out_hi_reg = 8'h00;
            16'h01: out_hi_reg = 8'h01;
            //...
            16'hff: out_hi_reg = 8'hff;
        endcase

        case (in[7:0])
            8'h00: out_lo_reg = 8'h00;
            8'h01: out_lo_reg = 8'h01;
            //...
            8'hff: out_lo_reg = 8'hff;
        endcase

        assign out_hi = out_hi_reg;
        assign out_lo = out_lo_reg;
    end

endmodule