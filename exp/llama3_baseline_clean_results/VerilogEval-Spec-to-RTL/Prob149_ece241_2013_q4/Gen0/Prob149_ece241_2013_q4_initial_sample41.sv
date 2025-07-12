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
        // Reset to a state equivalent to a low water level
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Store the current sensor state in the previous state register
        prev_s <= s;

        // Determine the current state based on the sensor inputs
        if (s == 3'b111) begin
            // Water level is above s[2], set flow rate to zero
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b110) begin
            // Water level is between s[2] and s[1]
            if (prev_s < s) begin
                // Water level is rising, open supplemental flow valve
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b1;
            end else begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b100) begin
            // Water level is between s[1] and s[0]
            if (prev_s < s) begin
                // Water level is rising, open supplemental flow valve
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b1;
            end else begin
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b000) begin
            // Water level is below s[0], set flow rate to maximum
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