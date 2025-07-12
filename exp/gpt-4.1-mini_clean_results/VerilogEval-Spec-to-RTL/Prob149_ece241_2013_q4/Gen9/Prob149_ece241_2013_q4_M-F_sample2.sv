module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding (monotonically increasing with water level)
    localparam BELOW_S0      = 2'd0; // no sensors asserted (000)
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only (001)
    localparam BETWEEN_S2_S1 = 2'd2; // s[1] and s[0] (011)
    localparam ABOVE_S2      = 2'd3; // all sensors asserted (111)

    // Decode water level from sensors: valid patterns only
    // Any invalid pattern defaults to BELOW_S0 (lowest level)
    function [1:0] decode_level;
        input [2:0] s_in;
        begin
            case (s_in)
                3'b000: decode_level = BELOW_S0;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b111: decode_level = ABOVE_S2;
                default: decode_level = BELOW_S0; // Treat invalid as below lowest sensor
            endcase
        end
    endfunction

    reg [1:0] prev_level;
    reg [1:0] curr_level_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: water level low for a long time
            prev_level    <= BELOW_S0;
            curr_level_reg <= BELOW_S0;
            fr0           <= 1'b1;
            fr1           <= 1'b1;
            fr2           <= 1'b1;
            dfr           <= 1'b1;
        end else begin
            curr_level_reg <= decode_level(s);
            // dfr asserted if water level is rising compared to previous level
            dfr <= (decode_level(s) > prev_level);
            prev_level <= curr_level_reg;

            // Nominal flow outputs based on current level
            // According to problem:
            // Above s[2]: no flows
            // Between s[2] and s[1]: fr0
            // Between s[1] and s[0]: fr0, fr1
            // Below s[0]: fr0, fr1, fr2
            case (curr_level_reg)
                ABOVE_S2: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S1_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Defensive default: treat as below lowest sensor
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase
        end
    end

endmodule