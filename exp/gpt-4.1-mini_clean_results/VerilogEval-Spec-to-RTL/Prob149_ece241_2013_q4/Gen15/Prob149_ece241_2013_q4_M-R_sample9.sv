module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level states encoded:
    // 0 = BELOW_S0 (no sensors asserted)
    // 1 = BETWEEN_S1_S0 (only s[0])
    // 2 = BETWEEN_S2_S1 (s[1], s[0])
    // 3 = ABOVE_S2 (all sensors)
    typedef enum logic [1:0] {
        BELOW_S0       = 2'd0,
        BETWEEN_S1_S0  = 2'd1,
        BETWEEN_S2_S1  = 2'd2,
        ABOVE_S2       = 2'd3
    } level_t;

    // Function to decode sensor inputs into water level state
    function automatic level_t decode_level(input [2:0] sensors);
        begin
            casez (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                default: decode_level = BELOW_S0; // conservative fallback
            endcase
        end
    endfunction

    reg [1:0] current_level, prev_level;
    reg       dfr_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] state with all flow valves and dfr open
            current_level <= BELOW_S0;
            prev_level    <= BELOW_S0;
            dfr_reg       <= 1'b1; // Supplemental valve open on reset per spec
        end else begin
            level_t decoded = decode_level(s);
            if (decoded != current_level) begin
                // Update levels and set dfr if water level increased
                dfr_reg    <= (decoded > current_level) ? 1'b1 : 1'b0;
                prev_level <= current_level;
                current_level <= decoded;
            end else begin
                // No sensor change, dfr off
                dfr_reg <= 1'b0;
            end
        end
    end

    // Generate nominal flow valve outputs from current water level state
    // According to problem statement:
    // BELOW_S0: fr0=1, fr1=1, fr2=1
    // BETWEEN_S1_S0: fr0=1, fr1=1, fr2=0
    // BETWEEN_S2_S1: fr0=1, fr1=0, fr2=0
    // ABOVE_S2: fr0=0, fr1=0, fr2=0

    assign fr0 = (current_level != ABOVE_S2) ? 1'b1 : 1'b0;
    assign fr1 = (current_level >= BETWEEN_S1_S0) && (current_level != ABOVE_S2) ? 1'b1 : 1'b0;
    assign fr2 = (current_level == BELOW_S0) ? 1'b1 : 1'b0;

    assign dfr = dfr_reg;

endmodule