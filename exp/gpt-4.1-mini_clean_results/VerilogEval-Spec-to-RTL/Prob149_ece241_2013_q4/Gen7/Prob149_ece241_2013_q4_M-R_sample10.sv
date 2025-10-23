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

    // Combinational function to decode water level exactly from sensor pattern per spec
    function automatic water_level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE;
                3'b011: decode_level = BETWEEN_2_1;
                3'b001: decode_level = BETWEEN_1_0;
                3'b000: decode_level = BELOW;
                default: decode_level = BELOW; // Any other pattern treated as BELOW for safety
            endcase
        end
    endfunction

    // Synchronous process updating current and previous water levels
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW;
            prev_level    <= BELOW;
        end else begin
            prev_level    <= current_level;
            current_level <= decode_level(s);
        end
    end

    // Nominal flow valve outputs (fr0, fr1, fr2) combinational logic
    // According to problem table:
    // ABOVE: none asserted (all 0)
    // BETWEEN_2_1: fr0 asserted only
    // BETWEEN_1_0: fr0 and fr1 asserted
    // BELOW: fr0, fr1, fr2 all asserted
    assign fr0 = (current_level != ABOVE) ? 1'b1 : 1'b0;
    assign fr1 = (current_level == BETWEEN_1_0 || current_level == BELOW) ? 1'b1 : 1'b0;
    assign fr2 = (current_level == BELOW) ? 1'b1 : 1'b0;

    // Supplemental flow valve (dfr) asserted if water level rises compared to previous level
    // On reset, dfr asserted (safe, max flow)
    reg dfr_reg;
    always @(posedge clk) begin
        if (reset)
            dfr_reg <= 1'b1;
        else
            dfr_reg <= (current_level > prev_level) ? 1'b1 : 1'b0;
    end

    assign dfr = dfr_reg;

endmodule