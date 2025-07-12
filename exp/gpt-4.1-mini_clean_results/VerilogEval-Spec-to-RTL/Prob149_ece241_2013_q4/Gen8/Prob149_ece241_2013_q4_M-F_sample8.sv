module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Enumerated water level states for clarity
    typedef enum logic [1:0] {
        BELOW       = 2'd0, // No sensors asserted
        BETWEEN_1_0 = 2'd1, // Only s[0] asserted
        BETWEEN_2_1 = 2'd2, // s[0] and s[1] asserted
        ABOVE       = 2'd3  // s[0], s[1], s[2] all asserted
    } water_level_t;

    water_level_t current_level, prev_level;

    // Function to decode water level from sensor inputs as per spec
    function automatic water_level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE;
                3'b011: decode_level = BETWEEN_2_1;
                3'b001: decode_level = BETWEEN_1_0;
                3'b000: decode_level = BELOW;
                default: decode_level = BELOW; // Treat any other pattern as BELOW for safety
            endcase
        end
    endfunction

    // Map water_level_t states to integer heights for comparison
    function automatic [1:0] level_height(input water_level_t level);
        begin
            case(level)
                BELOW:       level_height = 2'd0;
                BETWEEN_1_0: level_height = 2'd1;
                BETWEEN_2_1: level_height = 2'd2;
                ABOVE:       level_height = 2'd3;
                default:     level_height = 2'd0; // Defensive default
            endcase
        end
    endfunction

    // Sequential logic to store current and previous water levels
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW;
            prev_level    <= BELOW;
        end else begin
            prev_level    <= current_level;
            current_level <= decode_level(s);
        end
    end

    // Nominal flow valve outputs according to current_level
    assign fr0 = (current_level != ABOVE) ? 1'b1 : 1'b0;
    assign fr1 = (current_level == BETWEEN_1_0 || current_level == BELOW) ? 1'b1 : 1'b0;
    assign fr2 = (current_level == BELOW) ? 1'b1 : 1'b0;

    // Supplemental flow valve dfr: asserted if water level rises compared to previous level
    reg dfr_reg;
    always @(posedge clk) begin
        if (reset)
            dfr_reg <= 1'b1;
        else
            dfr_reg <= (level_height(current_level) > level_height(prev_level)) ? 1'b1 : 1'b0;
    end

    assign dfr = dfr_reg;

endmodule