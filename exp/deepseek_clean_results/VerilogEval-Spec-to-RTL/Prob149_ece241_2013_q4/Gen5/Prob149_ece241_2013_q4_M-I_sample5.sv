module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encoded water level states
    localparam LEVEL_ABOVE_S2  = 2'b00;
    localparam LEVEL_BETWEEN_S2_S1 = 2'b01;
    localparam LEVEL_BETWEEN_S1_S0 = 2'b10;
    localparam LEVEL_BELOW_S0  = 2'b11;

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Combinatorial level detection
    always @(*) begin
        case (s)
            3'b111: current_level = LEVEL_ABOVE_S2;
            3'b011: current_level = LEVEL_BETWEEN_S2_S1;
            3'b001: current_level = LEVEL_BETWEEN_S1_S0;
            3'b000: current_level = LEVEL_BELOW_S0;
            default: current_level = LEVEL_BELOW_S0; // Default to lowest level
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] state (all outputs high)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            // Store previous level
            prev_level <= current_level;

            // Nominal flow outputs
            case (current_level)
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
            endcase

            // Supplemental flow (rising water level)
            dfr <= (current_level < prev_level); // Current level is numerically higher
        end
    end

endmodule