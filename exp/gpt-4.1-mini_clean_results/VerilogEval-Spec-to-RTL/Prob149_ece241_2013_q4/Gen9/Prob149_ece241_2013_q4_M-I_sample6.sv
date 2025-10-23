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

    reg [1:0] current_state;
    reg [1:0] prev_state;
    reg [1:0] next_state;

    // Combinational decode of sensor input to water level state
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW;
            3'b001: next_state = BETWEEN_1_0;
            3'b011: next_state = BETWEEN_2_1;
            3'b111: next_state = ABOVE;
            default: next_state = BELOW; // Treat unexpected patterns as BELOW
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize as low water level with all valves open
            current_state <= BELOW;
            prev_state    <= BELOW;
            fr0           <= 1'b1;
            fr1           <= 1'b1;
            fr2           <= 1'b1;
            dfr           <= 1'b1;
        end else begin
            // Shift states: previous becomes old current; current becomes newly decoded
            prev_state    <= current_state;
            current_state <= next_state;

            // Generate nominal flow valves based on current water level
            case (next_state)
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

            // Supplemental flow valve asserted if water level rose since last clock
            dfr <= (current_state > prev_state) ? 1'b1 : 1'b0;
        end
    end

endmodule