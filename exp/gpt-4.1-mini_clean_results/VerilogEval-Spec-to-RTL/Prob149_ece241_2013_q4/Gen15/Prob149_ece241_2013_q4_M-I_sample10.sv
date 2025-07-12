module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
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
            if (sensors == 3'b111)
                decode_level = ABOVE_S2;
            else if ((sensors[2] == 0) && (sensors[1] == 1) && (sensors[0] == 1))
                decode_level = BETWEEN_S2_S1;
            else if (sensors == 3'b001)
                decode_level = BETWEEN_S1_S0;
            else if (sensors == 3'b000)
                decode_level = BELOW_S0;
            else begin
                // For partial sensor assertion, assign level by highest asserted sensor
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

    wire [1:0] decoded_level = decode_level(s);
    wire sensors_changed = (s != prev_sensors);

    // Nominal flow rates combinational from current_level
    reg fr2_r, fr1_r, fr0_r;
    always @(*) begin
        case (current_level)
            BELOW_S0:      {fr2_r, fr1_r, fr0_r} = 3'b111; // All valves open
            BETWEEN_S1_S0: {fr2_r, fr1_r, fr0_r} = 3'b011; // fr1, fr0 open
            BETWEEN_S2_S1: {fr2_r, fr1_r, fr0_r} = 3'b001; // fr0 open
            ABOVE_S2:      {fr2_r, fr1_r, fr0_r} = 3'b000; // No valves open
            default:       {fr2_r, fr1_r, fr0_r} = 3'b111; // Safe default
        endcase
    end

    // Assign nominal flow outputs
    assign fr2 = fr2_r;
    assign fr1 = fr1_r;
    assign fr0 = fr0_r;

    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            previous_level_before_change <= BELOW_S0;
            prev_sensors <= 3'b000;

            dfr <= 1'b1;
        end else begin
            prev_sensors <= s;

            if (sensors_changed)
                previous_level_before_change <= current_level;

            current_level <= decoded_level;

            // Supplemental valve logic: set if water level rose (current > previous)
            if (decoded_level > previous_level_before_change)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule