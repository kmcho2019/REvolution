module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states as localparams (2 bits)
    localparam [1:0]
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3;

    reg [1:0] current_level;
    reg [1:0] previous_level_before_change;
    reg [2:0] prev_sensors;

    // Function to decode sensors to water level state
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Priority decoding according to problem:
            // Above s[2]: s == 3'b111 => ABOVE_S2
            // Between s[2] and s[1]: s[2]==0 && s[1]==1 && s[0]==1 => BETWEEN_S2_S1
            // Between s[1] and s[0]: s == 3'b001 => BETWEEN_S1_S0
            // Below s[0]: s == 3'b000 => BELOW_S0
            // For other cases, interpret by priority of sensors asserted:
            if (sensors == 3'b111)
                decode_level = ABOVE_S2;
            else if ((sensors[2] == 0) && (sensors[1] == 1) && (sensors[0] == 1))
                decode_level = BETWEEN_S2_S1;
            else if (sensors == 3'b001)
                decode_level = BETWEEN_S1_S0;
            else if (sensors == 3'b000)
                decode_level = BELOW_S0;
            else begin
                // For intermediate/partial sensor assertion,
                // prioritize highest asserted sensor to assign level:
                if (sensors[2] == 1)
                    decode_level = ABOVE_S2;
                else if (sensors[1] == 1)
                    decode_level = BETWEEN_S2_S1;
                else if (sensors[0] == 1)
                    decode_level = BETWEEN_S1_S0;
                else
                    decode_level = BELOW_S0;
            end
        end
    endfunction

    wire sensors_changed = (s != prev_sensors);

    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            previous_level_before_change <= BELOW_S0;
            prev_sensors <= 3'b000;

            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_sensors <= s;

            // Get new level decoded from sensors
            // Use a temporary reg to hold function output
            reg [1:0] decoded_level;
            decoded_level = decode_level(s);

            // Update previous level before change if sensors changed
            if (sensors_changed)
                previous_level_before_change <= current_level;

            current_level <= decoded_level;

            // Nominal flow outputs based on current water level
            case (decoded_level)
                BELOW_S0:      {fr2, fr1, fr0} <= 3'b111; // All valves open
                BETWEEN_S1_S0: {fr2, fr1, fr0} <= 3'b011; // fr1, fr0 open
                BETWEEN_S2_S1: {fr2, fr1, fr0} <= 3'b001; // fr0 open
                ABOVE_S2:      {fr2, fr1, fr0} <= 3'b000; // No valves open
                default:       {fr2, fr1, fr0} <= 3'b111; // Safe default (all open)
            endcase

            // Supplemental flow valve (dfr) is asserted if water level rose
            // (current_level > previous_level_before_change)
            if (decoded_level > previous_level_before_change)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule