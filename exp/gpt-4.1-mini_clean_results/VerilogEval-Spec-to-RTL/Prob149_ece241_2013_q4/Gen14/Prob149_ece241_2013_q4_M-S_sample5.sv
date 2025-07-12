module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states as parameters (2-bit)
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] current_level;
    reg [1:0] previous_level_before_change;
    reg [2:0] prev_sensors;

    // Decode sensors into water level state (combinational function)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Based on sensor patterns from high to low
            if (sensors == 3'b111)
                decode_level = ABOVE_S2;
            else if (sensors == 3'b011)
                decode_level = BETWEEN_S2_S1;
            else if (sensors == 3'b001)
                decode_level = BETWEEN_S1_S0;
            else if (sensors == 3'b000)
                decode_level = BELOW_S0;
            else begin
                // Handle partial asserts as closest level below highest asserted sensor
                if (sensors[2])
                    decode_level = ABOVE_S2;
                else if (sensors[1])
                    decode_level = BETWEEN_S2_S1;
                else if (sensors[0])
                    decode_level = BETWEEN_S1_S0;
                else
                    decode_level = BELOW_S0;
            end
        end
    endfunction

    reg [1:0] decoded_level;

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
            decoded_level = decode_level(s);

            // On sensor change, update previous_level_before_change with old current_level
            if (sensors_changed)
                previous_level_before_change <= current_level;

            current_level <= decoded_level;

            // Nominal flow outputs based on current_level
            case (decoded_level)
                BELOW_S0:      {fr2, fr1, fr0} <= 3'b111; // All valves open
                BETWEEN_S1_S0: {fr2, fr1, fr0} <= 3'b011; // fr1, fr0 open
                BETWEEN_S2_S1: {fr2, fr1, fr0} <= 3'b001; // fr0 open
                ABOVE_S2:      {fr2, fr1, fr0} <= 3'b000; // No valves open
                default:       {fr2, fr1, fr0} <= 3'b111; // Safe default all open
            endcase

            // Supplemental valve dfr asserted if level rose compared to previous
            dfr <= (decoded_level > previous_level_before_change) ? 1'b1 : 1'b0;
        end
    end

endmodule