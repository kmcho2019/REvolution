module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encoded water levels
    localparam LEVEL_ABOVE_S2 = 2'd3;
    localparam LEVEL_S2_TO_S1 = 2'd2;
    localparam LEVEL_S1_TO_S0 = 2'd1;
    localparam LEVEL_BELOW_S0 = 2'd0;

    reg [1:0] current_level, prev_level;
    wire [1:0] next_level;

    // Priority encoder for water level (highest sensor takes precedence)
    assign next_level = (s[2]) ? LEVEL_ABOVE_S2 :
                       (s[1]) ? LEVEL_S2_TO_S1 :
                       (s[0]) ? LEVEL_S1_TO_S0 :
                       LEVEL_BELOW_S0;

    // Main sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;

            // Nominal flow outputs
            case (next_level)
                LEVEL_ABOVE_S2: {fr2, fr1, fr0} <= 3'b000;
                LEVEL_S2_TO_S1: {fr2, fr1, fr0} <= 3'b001;
                LEVEL_S1_TO_S0: {fr2, fr1, fr0} <= 3'b011;
                LEVEL_BELOW_S0: {fr2, fr1, fr0} <= 3'b111;
            endcase

            // Supplemental flow output (rising edge detection)
            dfr <= (next_level > current_level) && (current_level != LEVEL_BELOW_S0 || !reset);
        end
    end

endmodule