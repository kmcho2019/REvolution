module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding (ordinal, low to high)
    localparam BELOW       = 2'd0; // no sensors asserted
    localparam BETWEEN_1_0 = 2'd1; // only s[0] asserted
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE       = 2'd3; // all three sensors asserted

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Decode water level directly from sensors; only valid exact patterns
    always @(*) begin
        case (s)
            3'b000: current_level = BELOW;
            3'b001: current_level = BETWEEN_1_0;
            3'b011: current_level = BETWEEN_2_1;
            3'b111: current_level = ABOVE;
            default: current_level = BELOW; // Treat unexpected patterns as BELOW for simplicity
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Reset to "long low water" state: BELOW with all flows asserted
            prev_level <= BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= prev_level; // Hold prev_level by default; will update below

            // Update prev_level and outputs together
            prev_level <= prev_level == current_level ? prev_level : prev_level;
            prev_level <= current_level;

            // Assign nominal flow outputs per table
            case (current_level)
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

            // Assert dfr if water level rises compared to previous level
            dfr <= (current_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule