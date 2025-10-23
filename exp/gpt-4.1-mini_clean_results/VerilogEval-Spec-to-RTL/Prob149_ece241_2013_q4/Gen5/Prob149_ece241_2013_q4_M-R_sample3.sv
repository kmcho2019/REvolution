module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water level states
    typedef enum logic [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } level_t;

    // Decode sensor bits to water level
    function automatic level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011,
                3'b010: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                default: decode_level = BELOW_S0; // Safety fallback
            endcase
        end
    endfunction

    // Registers for current and previous water level
    reg [2:0] prev_sensors;
    level_t curr_level, prev_level;

    // Update water levels and dfr on clock edge
    always @(posedge clk) begin
        if (reset) begin
            curr_level  <= BELOW_S0;
            prev_level  <= BELOW_S0;
            prev_sensors <= 3'b000;
            dfr         <= 1'b1; // Supplemental flow valve ON at reset (long low level)
        end else begin
            if (s != prev_sensors) begin
                level_t next_level = decode_level(s);
                prev_level <= curr_level;
                curr_level <= next_level;
                prev_sensors <= s;

                // dfr asserted if water level is rising (current > previous)
                dfr <= (next_level > curr_level) ? 1'b1 : 1'b0;
            end else begin
                // No sensor change, dfr deasserted
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs are purely combinational from current level
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0 || curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule