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
    end else begin
        case (s)
            3'b111: begin // above the highest sensor
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b0;
                dfr_reg <= 1'b0;
            end
            3'b011: begin // between the highest and middle sensors
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                if (prev_s < s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            3'b001: begin // between the middle and lowest sensors
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            default: begin // below the lowest sensor
                fr2_reg <= 1'b1;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b1;
            end
        endcase
        prev_s <= s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule