module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    // Define water level ranks for comparison (0 = lowest)
    // Map sensor patterns to ranks:
    // 000 -> 0 (below lowest sensor)
    // 001 -> 1 (between s[1] and s[0])
    // 011 -> 2 (between s[2] and s[1])
    // 111 -> 3 (above s[2])
    // Other patterns treated as below lowest (0)
    function [1:0] water_level_rank;
        input [2:0] sensor;
        begin
            case(sensor)
                3'b000: water_level_rank = 2'd0;
                3'b001: water_level_rank = 2'd1;
                3'b011: water_level_rank = 2'd2;
                3'b111: water_level_rank = 2'd3;
                default: water_level_rank = 2'd0; // Treat unexpected as below lowest
            endcase
        end
    endfunction

    reg [2:0] prev_s, current_s;

    // Registers to hold outputs (for synchronous reset and stable outputs)
    reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

    // Capture sensor input each clock
    always @(posedge clk) begin
        if (reset) begin
            prev_s   <= 3'b000;
            current_s <= 3'b000;
            fr0_reg  <= 1'b1;
            fr1_reg  <= 1'b1;
            fr2_reg  <= 1'b1;
            dfr_reg  <= 1'b1;
        end else begin
            prev_s    <= current_s;
            current_s <= s;

            // Nominal flow valves according to current sensor pattern
            case (current_s)
                3'b111: begin // above highest sensor: no valves
                    fr0_reg <= 1'b0;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b011: begin // between s2 and s1
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b001: begin // between s1 and s0
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b0;
                end
                3'b000: begin // below lowest sensor
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
                default: begin // Treat unexpected as below lowest
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
            endcase

            // dfr asserted if water level rising (current rank > previous rank)
            dfr_reg <= (water_level_rank(current_s) > water_level_rank(prev_s)) ? 1'b1 : 1'b0;
        end
    end

    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = dfr_reg;

endmodule