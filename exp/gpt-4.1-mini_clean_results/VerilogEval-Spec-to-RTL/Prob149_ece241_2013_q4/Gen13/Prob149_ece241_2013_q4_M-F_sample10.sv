module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    // Decode sensors combinationally to water level
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;       // all sensors asserted
                3'b011: decode_level = BETWEEN_S2_S1; // top sensor not asserted
                3'b001: decode_level = BETWEEN_S1_S0; // only lowest sensor asserted
                3'b000: decode_level = BELOW_S0;       // no sensors asserted
                default: begin
                    // For partially asserted sensors not matching above:
                    // Priority from highest sensor to lowest
                    if (sensors[2]) decode_level = ABOVE_S2;
                    else if (sensors[1]) decode_level = BETWEEN_S2_S1;
                    else if (sensors[0]) decode_level = BETWEEN_S1_S0;
                    else decode_level = BELOW_S0;
                end
            endcase
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] prev_level_before_change;
    reg [2:0] prev_sensors;

    wire [1:0] new_level = decode_level(s);
    wire sensors_changed = (s != prev_sensors);

    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            prev_level_before_change <= BELOW_S0;
            prev_sensors <= 3'b000;
        end else begin
            prev_sensors <= s;

            if (sensors_changed) begin
                // Capture current_level before updating it to new_level
                prev_level_before_change <= current_level;
            end
            current_level <= new_level;
        end
    end

    // Nominal flow outputs combinational from current_level
    // Per spec:
    // Above s[2]: fr2=0, fr1=0, fr0=0
    // Between s[2] & s[1]: fr2=0, fr1=0, fr0=1
    // Between s[1] & s[0]: fr2=0, fr1=1, fr0=1
    // Below s[0]: fr2=1, fr1=1, fr0=1
    assign {fr2, fr1, fr0} =
        (current_level == BELOW_S0)       ? 3'b111 :
        (current_level == BETWEEN_S1_S0) ? 3'b011 :
        (current_level == BETWEEN_S2_S1) ? 3'b001 :
        (current_level == ABOVE_S2)       ? 3'b000 :
        3'b111; // default safe output

    // Supplemental flow valve asserted when water level rose since last sensor change
    // dfr = 1 when current_level > prev_level_before_change
    assign dfr = (current_level > prev_level_before_change);

endmodule