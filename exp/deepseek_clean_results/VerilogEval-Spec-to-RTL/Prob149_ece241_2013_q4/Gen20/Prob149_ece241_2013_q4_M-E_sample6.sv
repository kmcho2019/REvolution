module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level encoding
    localparam LEVEL_BELOW  = 2'b00; // No sensors
    localparam LEVEL_LOW    = 2'b01; // s[0] only
    localparam LEVEL_MID    = 2'b10; // s[1:0]
    localparam LEVEL_HIGH   = 2'b11; // s[2:0]

    reg [1:0] current_level;
    reg prev_s0;
    wire s0_rising;

    // Detect rising edge of s[0]
    assign s0_rising = s[0] & ~prev_s0;

    // Priority encoder for water level
    always @(*) begin
        casez (s)
            3'b??1: current_level = LEVEL_HIGH;
            3'b?10: current_level = LEVEL_MID;
            3'b100: current_level = LEVEL_LOW;
            default: current_level = LEVEL_BELOW;
        endcase
    end

    // Track s[0] history for edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s0 <= 1'b0;
        end else begin
            prev_s0 <= s[0];
        end
    end

    // Output generation
    always @(*) begin
        if (reset) begin
            // Maximum flow during reset
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            // Nominal flow based on current level
            case (current_level)
                LEVEL_BELOW: {fr2, fr1, fr0} = 3'b111;
                LEVEL_LOW:   {fr2, fr1, fr0} = 3'b011;
                LEVEL_MID:   {fr2, fr1, fr0} = 3'b001;
                LEVEL_HIGH:  {fr2, fr1, fr0} = 3'b000;
                default:    {fr2, fr1, fr0} = 3'b111;
            endcase

            // Supplemental flow only when rising from below
            dfr = (current_level == LEVEL_LOW && s0_rising) ||
                  (current_level == LEVEL_MID && s0_rising);
        end
    end

endmodule