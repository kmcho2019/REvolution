module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous sensor state
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

always @(posedge clk) begin
    if (reset) begin
        // reset to a state equivalent to a low water level
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000; // no sensors asserted
    end else begin
        // determine the flow rate based on the current water level and the previous state
        if (s == 3'b111) begin // Above s[2]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b110) begin // Between s[2] and s[1]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            if (prev_s < s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b100) begin // Between s[1] and s[0]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (prev_s < s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else begin // Below s[0]
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end
        // update the previous sensor state
        prev_s <= s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule