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
reg [2:0] curr_s;
reg fr2_reg;
reg fr1_reg;
reg fr0_reg;
reg dfr_reg;

always @(posedge clk) begin
    if (reset) begin
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        curr_s <= s;
        if (curr_s == 3'b111) begin // above s[2]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (curr_s == 3'b110) begin // between s[2] and s[1]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            if (curr_s > prev_s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (curr_s == 3'b100) begin // between s[1] and s[0]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (curr_s > prev_s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (curr_s == 3'b000) begin // below s[0]
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end else if (curr_s == 3'b001) begin // between s[0] and none
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (curr_s > prev_s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end
        prev_s <= curr_s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule