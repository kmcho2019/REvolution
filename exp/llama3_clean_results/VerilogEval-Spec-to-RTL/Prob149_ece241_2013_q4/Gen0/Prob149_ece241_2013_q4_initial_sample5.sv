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

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset state: all outputs asserted, no sensors asserted
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Determine current state based on sensors
        if (s == 3'b111) begin
            // Above s[2]: no flow
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b011) begin
            // Between s[2] and s[1]: nominal flow rate fr0
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            // Check if previous level was lower than current level
            if ((prev_s < s) && (prev_s!= 3'b000)) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else if (s == 3'b001) begin
            // Between s[1] and s[0]: nominal flow rate fr0, fr1
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            // Check if previous level was lower than current level
            if ((prev_s < s) && (prev_s!= 3'b000)) begin
                dfr_reg <= 1'b1;
            end else begin
                dfr_reg <= 1'b0;
            end
        end else begin
            // Below s[0]: maximum flow rate
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end

        // Update previous state
        prev_s <= s;
    end
end

endmodule