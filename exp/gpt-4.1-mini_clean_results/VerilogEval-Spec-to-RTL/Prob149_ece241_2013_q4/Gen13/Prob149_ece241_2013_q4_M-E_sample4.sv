module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states as enums
    typedef enum reg [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } water_level_t;

    water_level_t current_level;
    water_level_t previous_level_before_change;
    reg [2:0] prev_sensors;

    // Function to decode sensors to water level state
    function water_level_t decode_level(input [2:0] sensors);
        begin
            // From highest to lowest priority
            if (sensors == 3'b111)            decode_level = ABOVE_S2;
            else if (sensors[2] == 0 && sensors[1] == 1 && sensors[0] == 1) decode_level = BETWEEN_S2_S1;
            else if (sensors == 3'b001)       decode_level = BETWEEN_S1_S0;
            else if (sensors == 3'b000)       decode_level = BELOW_S0;
            else begin
                // Handle intermediate or partial sensor cases:
                if (sensors[2])                decode_level = ABOVE_S2;
                else if (sensors[1])           decode_level = BETWEEN_S2_S1;
                else if (sensors[0])           decode_level = BETWEEN_S1_S0;
                else                          decode_level = BELOW_S0;
            end
        end
    endfunction

    // Detect if sensors changed since last clock
    wire sensors_changed = (s != prev_sensors);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize to lowest level and all flows asserted
            current_level <= BELOW_S0;
            previous_level_before_change <= BELOW_S0;
            prev_sensors <= 3'b000;

            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_sensors <= s;

            // Decode new level from sensor inputs
            water_level_t decoded_level = decode_level(s);

            // On sensor change, update previous_level_before_change with old current_level
            if (sensors_changed) begin
                previous_level_before_change <= current_level;
            end

            current_level <= decoded_level;

            // Nominal flow outputs logic based on current level
            case (decoded_level)
                BELOW_S0:      {fr2, fr1, fr0} <= 3'b111; // All valves open
                BETWEEN_S1_S0: {fr2, fr1, fr0} <= 3'b011; // fr1, fr0 open
                BETWEEN_S2_S1: {fr2, fr1, fr0} <= 3'b001; // fr0 open
                ABOVE_S2:      {fr2, fr1, fr0} <= 3'b000; // No valves open
                default:       {fr2, fr1, fr0} <= 3'b111; // Safe default: all open
            endcase

            // Supplemental flow valve logic: asserted if water level rose on last sensor change
            // i.e., current_level > previous_level_before_change
            if (current_level > previous_level_before_change)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule