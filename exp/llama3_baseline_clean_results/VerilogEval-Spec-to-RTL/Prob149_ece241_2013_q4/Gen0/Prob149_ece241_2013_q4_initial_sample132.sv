module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg prev_s2, prev_s1, prev_s0;
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

always @(posedge clk) begin
    if (reset) begin
        prev_s2 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s0 <= 1'b0;
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
    end else begin
        prev_s2 <= s[2];
        prev_s1 <= s[1];
        prev_s0 <= s[0];

        if (s[2] && s[1] && s[0]) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s[1] && s[0]) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            if ((s[1] && !prev_s1) || (s[0] && !prev_s0)) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s[0]) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (!prev_s0) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else begin
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule