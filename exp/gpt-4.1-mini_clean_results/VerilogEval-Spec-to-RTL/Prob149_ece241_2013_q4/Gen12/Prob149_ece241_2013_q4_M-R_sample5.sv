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

    // Registers for current and previous water level, and previous sensors
    reg [1:0] current_level;
    reg [1:0] prev_level_before_change;
    reg [2:0] prev_sensors;

    // Detect sensor change
    wire sensors_changed = (s != prev_sensors);

    // Sequential logic: update stored levels on clock edge
    always @(posedge clk) begin
        if (reset) begin
            current_level          <= BELOW_S0;
            prev_level_before_change <= BELOW_S0;
            prev_sensors           <= 3'b000;
        end else begin
            prev_sensors <= s;
            if (sensors_changed) begin
                // On sensor change, capture current level before updating
                prev_level_before_change <= current_level;
            end
            // Update current level each clock cycle
            current_level <= decode_level(s);
        end
    end

    // Nominal flow outputs combinational from current_level
    assign {fr2, fr1, fr0} =
        (current_level == BELOW_S0)      ? 3'b111 :
        (current_level == BETWEEN_S1_S0) ? 3'b011 :
        (current_level == BETWEEN_S2_S1) ? 3'b001 :
        (current_level == ABOVE_S2)      ? 3'b000 :
        3'b111; // default safe output

    // Supplemental flow valve (dfr) asserted when current_level > prev_level_before_change
    // At reset, dfr asserted as per spec, so handle reset condition combinationally
    assign dfr = (reset) ? 1'b1 : (current_level > prev_level_before_change);

endmodule