module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding for clarity
    localparam LEVEL_BELOW  = 2'd0; // no sensors asserted
    localparam LEVEL_S0     = 2'd1; // only s[0]
    localparam LEVEL_S1_S0  = 2'd2; // s[0] and s[1]
    localparam LEVEL_ABOVE  = 2'd3; // all sensors asserted (s[0], s[1], s[2])

    // Function to decode sensor vector into water level code
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = LEVEL_ABOVE;
                3'b011: decode_level = LEVEL_S1_S0;
                3'b001: decode_level = LEVEL_S0;
                default: decode_level = LEVEL_BELOW;
            endcase
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] prev_level;
    reg [1:0] stable_level;       // Last stable sensor level
    reg       stable_sensor_valid; // Flag indicating stable_level is valid

    wire [1:0] sensor_level = decode_level(s);

    // Detect sensor level change by comparing input decoded level to stable_level
    wire sensor_changed = (sensor_level != stable_level);

    // Update current_level every clock; it tracks the sensor input level synchronously
    always @(posedge clk) begin
        if (reset) begin
            // On reset, assume water is below lowest sensor, all flows asserted and dfr = 1
            current_level       <= LEVEL_BELOW;
            prev_level          <= LEVEL_BELOW;
            stable_level        <= LEVEL_BELOW;
            stable_sensor_valid <= 1'b1;
        end else begin
            current_level <= sensor_level;

            // When sensor input changes to a new level, update prev_level to previous stable_level
            // and update stable_level to new sensor_level
            if (sensor_changed) begin
                // Record the previous stable level
                prev_level   <= stable_level;
                stable_level <= sensor_level;
                stable_sensor_valid <= 1'b1;
            end
            // If no change, maintain previous values
        end
    end

    // Supplemental flow valve (dfr) asserted only if current level is strictly greater than previous stable level
    // Only valid when stable_sensor_valid is high (avoid invalid comparison after reset)
    assign dfr = stable_sensor_valid && (current_level > prev_level);

    // Nominal flows combinationally driven by current_level per specification
    assign fr0 = (current_level != LEVEL_ABOVE); // fr0 asserted if not above highest sensor
    assign fr1 = (current_level == LEVEL_S0) || (current_level == LEVEL_BELOW);
    assign fr2 = (current_level == LEVEL_BELOW);

endmodule