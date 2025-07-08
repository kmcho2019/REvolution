module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states as localparams
    localparam LEVEL_BELOW_S0 = 2'd0;
    localparam LEVEL_BETWEEN_S1_S0 = 2'd1;
    localparam LEVEL_BETWEEN_S2_S1 = 2'd2;
    localparam LEVEL_ABOVE_S2 = 2'd3;

    // Register to hold previous water level
    reg [1:0] prev_level;

    // Function to determine water level category from sensor input
    function [1:0] get_level;
        input [2:0] s_in;
        begin
            case (s_in)
                3'b111: get_level = LEVEL_ABOVE_S2;          // all sensors asserted
                3'b011: get_level = LEVEL_BETWEEN_S2_S1;     // s0,s1 asserted only
                3'b001: get_level = LEVEL_BETWEEN_S1_S0;     // s0 asserted only
                3'b000: get_level = LEVEL_BELOW_S0;           // no sensors asserted
                default: begin
                    // If unexpected sensor combination, assign based on highest sensor asserted
                    // but based on description only these four states are expected.
                    // To be safe, interpret any other pattern as the highest asserted sensor defines level.
                    if (s_in[2]) get_level = LEVEL_ABOVE_S2;
                    else if (s_in[1]) get_level = LEVEL_BETWEEN_S2_S1;
                    else if (s_in[0]) get_level = LEVEL_BETWEEN_S1_S0;
                    else get_level = LEVEL_BELOW_S0;
                end
            endcase
        end
    endfunction

    // Registers to track current level
    reg [1:0] curr_level;

    // Detect sensor state change
    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, treat as long time below lowest sensor
            prev_level <= LEVEL_BELOW_S0;
            prev_s <= 3'b000;
            // all flow outputs asserted at reset
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            curr_level = get_level(s);

            // Update prev_level only on sensor state change
            if (s != prev_s) begin
                prev_level <= curr_level;
                prev_s <= s;
            end else begin
                prev_level <= prev_level; // hold
                prev_s <= prev_s;
            end

            // Determine if water level is rising (current > previous)
            // If rising, dfr = 1 else 0
            // Note that if levels are equal or falling, dfr=0

            // Set nominal flow rates according to current level
            case (curr_level)
                LEVEL_ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                LEVEL_BETWEEN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                LEVEL_BETWEEN_S1_S0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                LEVEL_BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                default: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase

            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule