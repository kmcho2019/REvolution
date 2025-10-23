module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding as localparams (2-bit values)
    localparam [1:0] BELOW    = 2'd0;  // no sensors asserted
    localparam [1:0] BTWN_10  = 2'd1;  // s[0] asserted only
    localparam [1:0] BTWN_21  = 2'd2;  // s[1], s[0] asserted
    localparam [1:0] ABOVE    = 2'd3;  // s[2], s[1], s[0] asserted

    // Synchronize sensor inputs to clk domain to avoid glitches
    reg [2:0] s_sync_0, s_sync_1;
    always @(posedge clk) begin
        if (reset) begin
            s_sync_0 <= 3'b0;
            s_sync_1 <= 3'b0;
        end else begin
            s_sync_0 <= s;
            s_sync_1 <= s_sync_0;
        end
    end

    // Function to decode water level from synchronized sensor inputs
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            if (sensors[2])
                decode_level = ABOVE;
            else if (sensors[1])
                decode_level = BTWN_21;
            else if (sensors[0])
                decode_level = BTWN_10;
            else
                decode_level = BELOW;
        end
    endfunction

    // Registers for current and previous water levels
    reg [1:0] curr_level;
    reg [1:0] prev_level;
    reg [1:0] curr_level_dly;  // delayed version of curr_level for change detection

    // Decode level from synchronized sensors
    wire [1:0] sensor_level = decode_level(s_sync_1);

    always @(posedge clk) begin
        if (reset) begin
            curr_level     <= BELOW;
            prev_level     <= BELOW;
            curr_level_dly <= BELOW;
        end else begin
            // Save current level delayed for edge detection
            curr_level_dly <= curr_level;

            // Update curr_level to sensor_level
            curr_level <= sensor_level;

            // When curr_level changes, update prev_level to previous curr_level (from curr_level_dly)
            if (sensor_level != curr_level_dly) begin
                prev_level <= curr_level_dly;
            end
            // else prev_level holds previous value
        end
    end

    // Nominal flow rate outputs based on current water level
    wire fr0_nominal = (curr_level <= BTWN_21);
    wire fr1_nominal = (curr_level <= BTWN_10);
    wire fr2_nominal = (curr_level == BELOW);

    // Supplemental flow valve asserted if water level has increased since previous stable level
    wire dfr_nominal = (curr_level > prev_level);

    // Outputs combinationally assigned
    assign fr0 = fr0_nominal;
    assign fr1 = fr1_nominal;
    assign fr2 = fr2_nominal;
    assign dfr = dfr_nominal;

endmodule