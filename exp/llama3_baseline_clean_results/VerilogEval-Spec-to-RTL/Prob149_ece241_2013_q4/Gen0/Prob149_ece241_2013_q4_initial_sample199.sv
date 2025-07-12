module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
        
        if (s == 3'b111) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b110) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            if ((s > prev_s) && (prev_s != 3'b000)) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b100) begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if ((s > prev_s) && (prev_s != 3'b000)) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b000) begin
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end else begin
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule