module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    reg [3:0] out_reg;
    reg valid_reg;

    always @(*) begin
        out_reg = 4'd0;
        valid_reg = 1'b0;

        case (code)
            8'h45: out_reg = 4'd0;
            8'h16: out_reg = 4'd1;
            8'h1e: out_reg = 4'd2;
            8'h26: out_reg = 4'd3;
            8'h25: out_reg = 4'd4;
            8'h2e: out_reg = 4'd5;
            8'h36: out_reg = 4'd6;
            8'h3d: out_reg = 4'd7;
            8'h3e: out_reg = 4'd8;
            8'h46: out_reg = 4'd9;
        endcase

        if (code == 8'h45 || code == 8'h16 || code == 8'h1e || code == 8'h26 ||
            code == 8'h25 || code == 8'h2e || code == 8'h36 || code == 8'h3d ||
            code == 8'h3e || code == 8'h46) begin
            valid_reg = 1'b1;
        end
    end

    assign out = out_reg;
    assign valid = valid_reg;

endmodule