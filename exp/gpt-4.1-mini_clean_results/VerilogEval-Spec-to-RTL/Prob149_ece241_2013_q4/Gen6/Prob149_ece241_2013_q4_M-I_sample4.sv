module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW       = 2'd0; // No sensors asserted
    localparam BETWEEN_1_0 = 2'd1; // Only s[0] asserted
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE       = 2'd3; // All sensors asserted

    reg [1:0] current_state;
    reg [1:0] prev_state;
    reg [1:0] decoded_level;

    // Combinational decode water level from sensors
    always @(*) begin
        if (s == 3'b111)            decoded_level = ABOVE;
        else if (s[2:1] == 2'b11)  decoded_level = ABOVE; // Defensive: treat any top two asserted as ABOVE
        else if (s == 3'b011)       decoded_level = BETWEEN_2_1;
        else if (s == 3'b001)       decoded_level = BETWEEN_1_0;
        else if (s == 3'b000)       decoded_level = BELOW;
        else if (s[1:0] == 2'b01)   decoded_level = BETWEEN_1_0;  // e.g. 010 not expected but handled
        else if (s[1] == 1'b1)      decoded_level = BETWEEN_2_1;  // any 0x1x treated as BETWEEN_2_1
        else                        decoded_level = BELOW;        // default fallback
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state    <= BELOW;

            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1; // Reset state simulates long low water level with dfr asserted
        end else begin
            prev_state    <= current_state;
            current_state <= decoded_level;

            // Nominal flow valve outputs
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

            // Supplemental flow valve dfr asserted if water level rises
            dfr <= (decoded_level > prev_state) ? 1'b1 : 1'b0;
        end
    end

endmodule