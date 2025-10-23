module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level zones encoding
    localparam ABOVE_S2   = 2'b00;
    localparam BTWN_S2_S1 = 2'b01;
    localparam BTWN_S1_S0 = 2'b10;
    localparam BELOW_S0   = 2'b11;

    reg [1:0] curr_level, prev_level;

    // Priority encoder for water level detection
    always @(*) begin
        casez (s)
            3'b??1: curr_level = ABOVE_S2;    // s[2] active (highest priority)
            3'b?10: curr_level = BTWN_S2_S1;  // s[1] active but not s[2]
            3'b100: curr_level = BTWN_S1_S0;  // only s[0] active
            3'b000: curr_level = BELOW_S0;     // no sensors active
            default: curr_level = BELOW_S0;    // handle undefined cases
        endcase
    end

    // Output generation and state tracking
    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] state with all outputs high
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= BELOW_S0;
        end else begin
            // Track previous level for transition detection
            prev_level <= curr_level;

            // Nominal flow outputs based on current level
            case (curr_level)
                ABOVE_S2:   {fr2, fr1, fr0} <= 3'b000;
                BTWN_S2_S1: {fr2, fr1, fr0} <= 3'b001;
                BTWN_S1_S0: {fr2, fr1, fr0} <= 3'b011;
                BELOW_S0:   {fr2, fr1, fr0} <= 3'b111;
            endcase

            // Supplemental flow when water level is rising
            dfr <= (curr_level > prev_level);
        end
    end

endmodule