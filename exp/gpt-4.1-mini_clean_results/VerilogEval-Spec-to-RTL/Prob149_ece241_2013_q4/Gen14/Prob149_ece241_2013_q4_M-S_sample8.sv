module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Previous sensor input register to detect changes
    reg [2:0] prev_s;

    // Water level decoding as per sensor patterns
    // According to problem:
    // Above s[2]: s = 3'b111 (all sensors asserted)
    // Between s[2] and s[1]: s = 3'b011 (s[1]=1,s[0]=1,s[2]=0)
    // Between s[1] and s[0]: s = 3'b001 (only s[0]=1)
    // Below s[0]: s = 3'b000 (no sensors asserted)

    // We'll define a function to get water level ordinal for comparison:
    // 0 = BELOW_S0 (no sensors)
    // 1 = BETWEEN_S1_S0 (only s[0])
    // 2 = BETWEEN_S2_S1 (s[1], s[0])
    // 3 = ABOVE_S2 (all sensors)

    function automatic [1:0] water_level(input [2:0] sensors);
        begin
            casez (sensors)
                3'b111: water_level = 2'd3; // ABOVE_S2
                3'b011: water_level = 2'd2; // BETWEEN_S2_S1
                3'b001: water_level = 2'd1; // BETWEEN_S1_S0
                3'b000: water_level = 2'd0; // BELOW_S0
                default: water_level = 2'd0; // treat other patterns as BELOW_S0 conservatively
            endcase
        end
    endfunction

    wire [1:0] current_level = water_level(s);
    reg  [1:0] prev_level;

    // Determine if water level increased (current_level > prev_level) to assert dfr
    reg dfr_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_s     <= 3'b000;    // below s[0] sensors (no sensors asserted)
            prev_level <= 2'd0;      // BELOW_S0
            dfr_reg    <= 1'b0;
        end else begin
            // Update prev_s and prev_level only when sensors change
            if (s != prev_s) begin
                dfr_reg    <= (water_level(s) > prev_level) ? 1'b1 : 1'b0;
                prev_s     <= s;
                prev_level <= water_level(s);
            end else begin
                dfr_reg <= 1'b0; // No sensor change => no dfr assert
            end
        end
    end

    assign dfr = dfr_reg;

    // Assign flow rate valves nominally according to sensor pattern:
    // ABOVE_S2 (3'b111): fr2=0, fr1=0, fr0=0
    // BETWEEN_S2_S1 (3'b011): fr2=0, fr1=0, fr0=1
    // BETWEEN_S1_S0 (3'b001): fr2=0, fr1=1, fr0=1
    // BELOW_S0 (3'b000): fr2=1, fr1=1, fr0=1
    // All other patterns also treated as BELOW_S0 conservatively

    assign fr2 = (s == 3'b000) ? 1'b1 : 1'b0;
    assign fr1 = (s == 3'b001 || s == 3'b000) ? 1'b1 : 1'b0;
    assign fr0 = (s != 3'b111) ? 1'b1 : 1'b0;

endmodule