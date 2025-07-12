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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize state machine to a state where all sensors are de-asserted and all flow rates are at maximum
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Check current water level sensors and adjust flow rate accordingly
        if (s[2]) begin
            // Water level is above the highest sensor, turn off all flow rates
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s[1]) begin
            // Water level is between the upper and lower sensors
            if (s[0]) begin
                // Water level is between s[1] and s[0]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                if (prev_s < s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end else begin
                // Water level is between s[2] and s[1]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                if (prev_s < s) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
        end else if (s[0]) begin
            // Water level is between s[1] and s[0]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (prev_s < s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else begin
            // Water level is below the lowest sensor, turn on all flow rates
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end
        prev_s <= s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule