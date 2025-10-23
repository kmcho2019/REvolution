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
        // Reset to a state equivalent to a low water level
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Update previous sensors
        prev_s <= s;
        
        // Determine current state
        if (s == 3'b111) begin
            // Above the highest sensor
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b011) begin
            // Between the highest and middle sensors
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            if (prev_s < s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b001) begin
            // Between the middle and lowest sensors
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            if (prev_s < s) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else begin
            // Below the lowest sensor
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