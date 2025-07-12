module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

always @(posedge clk) begin
    if (reset) begin
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;

        case (s)
            3'b000: begin
                fr2_reg <= 1'b1;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b1;
            end
            3'b001: begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < s) dfr_reg <= 1'b1;
                else dfr_reg <= 1'b0;
            end
            3'b011: begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < s) dfr_reg <= 1'b1;
                else dfr_reg <= 1'b0;
            end
            3'b111: begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b0;
                dfr_reg <= 1'b0;
            end
            default: begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                if (prev_s < s) dfr_reg <= 1'b1;
                else dfr_reg <= 1'b0;
            end
        endcase
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule