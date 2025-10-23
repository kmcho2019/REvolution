module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    reg [2:0] prev_s;
    reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

    // Function to assign a water level rank:
    // Higher number = higher water level
    // Ranking order:
    // 3'b111 = 3 (above highest)
    // 3'b011 = 2 (between s2 and s1)
    // 3'b001 = 1 (between s1 and s0)
    // default = 0 (below lowest, including 000 and others)
    function [1:0] water_level_rank;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: water_level_rank = 2'd3;
                3'b011: water_level_rank = 2'd2;
                3'b001: water_level_rank = 2'd1;
                default: water_level_rank = 2'd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            fr0_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr2_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end else begin
            // Nominal flow valve outputs based on current sensors
            case (s)
                3'b111: begin
                    fr0_reg <= 1'b0;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b011: begin
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b001: begin
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b0;
                end
                3'b000: begin
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
                default: begin
                    // Treat all other inputs as below lowest sensor
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
            endcase

            // Supplemental flow valve active if water level increased
            dfr_reg <= (water_level_rank(s) > water_level_rank(prev_s)) ? 1'b1 : 1'b0;

            prev_s <= s;
        end
    end

    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = dfr_reg;

endmodule