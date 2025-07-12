module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;  // previous water level
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;  // registered outputs

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;  // all sensors deasserted
    end else begin
        // Update flow rate based on current water level
        if (s == 3'b111) begin  // Above s[2]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b110) begin  // Between s[2] and s[1]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            dfr_reg <= (prev_s < s);  // Supplemental flow valve if level increased
        end else if (s == 3'b100) begin  // Between s[1] and s[0]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= (prev_s < s);  // Supplemental flow valve if level increased
        end else if (s == 3'b000 || s == 3'b001 || s == 3'b010 || s == 3'b011) begin  // Below s[0]
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end
        // Update previous water level
        prev_s <= s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule