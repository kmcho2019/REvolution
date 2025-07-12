module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level states encoding (ordinal from lowest to highest)
    localparam BELOW       = 2'd0; // No sensors asserted (below s[0])
    localparam BETWEEN_1_0 = 2'd1; // Only s[0] asserted (between s[1] and s[0])
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted (between s[2] and s[1])
    localparam ABOVE       = 2'd3; // All sensors asserted (above s[2])

    reg [1:0] current_state, prev_state;
    reg [1:0] decoded_level;

    // Decode water level exactly matching sensor states from problem description
    always @(*) begin
        case (s)
            3'b000: decoded_level = BELOW;
            3'b001: decoded_level = BETWEEN_1_0;
            3'b011: decoded_level = BETWEEN_2_1;
            3'b111: decoded_level = ABOVE;
            default: decoded_level = BELOW; // Treat unexpected patterns as BELOW (lowest level)
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state    <= BELOW;
            // Reset condition: all nominal flows and supplemental flow asserted
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state    <= current_state;
            current_state <= decoded_level;

            // Nominal flow valves according to water level
            case (decoded_level)
                ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_2_1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_1_0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve asserted if water level rose compared to previous cycle
            dfr <= (current_state > prev_state) ? 1'b1 : 1'b0;
        end
    end

endmodule