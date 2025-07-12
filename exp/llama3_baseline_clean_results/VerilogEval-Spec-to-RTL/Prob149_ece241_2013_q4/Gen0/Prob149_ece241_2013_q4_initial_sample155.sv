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
        curr_s <= 3'b000;
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
    end else begin
        prev_s <= curr_s;
        curr_s <= s;

        case (curr_s)
            3'b000: begin // Below s[0]
                fr2_reg <= 1'b1;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < curr_s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b1;
                end
            end
            3'b001: begin // Between s[1] and s[0]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < curr_s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            3'b011: begin // Between s[2] and s[1]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                if (prev_s < curr_s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            default: begin // Above s[2]
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