module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg  dfr
);

    // Water level encoding
    localparam BELOW_S0       = 2'd0;
    localparam BETWEEN_S1_S0  = 2'd1;
    localparam BETWEEN_S2_S1  = 2'd2;
    localparam ABOVE_S2       = 2'd3;

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

    reg [2:0] prev_sensors;
    reg [1:0] current_level;
    reg [1:0] prev_level_before_change;

    wire sensors_changed = (s != prev_sensors);

    // Sequential logic:
    // On sensor change: latch previous level before updating current_level
    // Then update current_level with decoded input
    always @(posedge clk) begin
        if (reset) begin
            prev_sensors           <= 3'b000;
            current_level          <= BELOW_S0;
            prev_level_before_change <= BELOW_S0;
            dfr                    <= 1'b1; // At reset dfr asserted as per spec
        end else begin
            prev_sensors <= s;

            if (sensors_changed) begin
                // Latch current_level as prev_level_before_change before updating current_level
                prev_level_before_change <= current_level;
                current_level <= decode_level(s);
            end else begin
                // No sensor change, just update current_level normally
                current_level <= decode_level(s);
                // Maintain prev_level_before_change as is
            end

            // Update dfr after updating levels
            // dfr asserted if current_level > prev_level_before_change (water level rising)
            dfr <= (current_level > prev_level_before_change);
        end
    end

    // Nominal flow outputs combinational from current_level
    assign {fr2, fr1, fr0} =
        (current_level == BELOW_S0)       ? 3'b111 :
        (current_level == BETWEEN_S1_S0)  ? 3'b011 :
        (current_level == BETWEEN_S2_S1)  ? 3'b001 :
        (current_level == ABOVE_S2)        ? 3'b000 :
        3'b111; // default safe output

endmodule