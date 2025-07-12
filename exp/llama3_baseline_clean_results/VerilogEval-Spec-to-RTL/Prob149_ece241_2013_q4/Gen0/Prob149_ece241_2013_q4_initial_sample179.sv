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
        prev_s <= 3'b000;
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
    end else begin
        prev_s <= s;
        case (s)
            3'b000: begin // Below s[0]
                fr2_reg <= 1'b1;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b1;
            end
            3'b001: begin // Between s[0] and s[1]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s == 3'b000) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            3'b011: begin // Between s[1] and s[2]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                if (prev_s == 3'b001) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            3'b111: begin // Above s[2]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b0;
                dfr_reg <= 1'b0;
            end
            default: begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b0;
                dfr_reg <= 1'b0;
            end
        endcase
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule