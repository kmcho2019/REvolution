module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define states representing water level regions
    typedef enum reg [1:0] {
        BELOW       = 2'd0,
        BETWEEN_1_0 = 2'd1,
        BETWEEN_2_1 = 2'd2,
        ABOVE       = 2'd3
    } state_t;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // Function to decode state from sensor input s
    function state_t decode_region(input [2:0] sensors);
        begin
            // Sensors:
            // s[2] - highest sensor
            // s[1] - middle sensor
            // s[0] - lowest sensor

            // According to problem:
            // ABOVE: s[0], s[1], s[2] all asserted
            // BETWEEN_2_1: s[0], s[1] asserted, s[2] not asserted
            // BETWEEN_1_0: s[0] asserted only
            // BELOW: no sensors asserted
            // If sensor pattern doesn't fit above exactly, select closest valid state:
            // Priority from highest to lowest (above to below)

            if (sensors == 3'b111)
                decode_region = ABOVE;
            else if (sensors[1:0] == 2'b11 && sensors[2] == 1'b0)
                decode_region = BETWEEN_2_1;
            else if (sensors == 3'b001)
                decode_region = BETWEEN_1_0;
            else if (sensors == 3'b000)
                decode_region = BELOW;
            else begin
                // Handle uncommon or invalid sensor combinations by choosing nearest region:
                // If s[0] asserted (bit0=1), but s[1] and s[2] different from exact patterns:
                // For s=3'b101 or 3'b100 or 3'b010, fallback to BELOW for safety
                // or assign region based on number of sensors asserted:

                // Count how many sensors asserted
                integer count;
                count = sensors[0] + sensors[1] + sensors[2];

                // Map count to region conservatively
                case (count)
                    3: decode_region = ABOVE;
                    2: decode_region = BETWEEN_2_1;
                    1: decode_region = BETWEEN_1_0;
                    default: decode_region = BELOW;
                endcase
            end
        end
    endfunction

    // Synchronous state register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= decode_region(s);
        end
    end

    // Nominal flow valve outputs combinationally from current state
    // Mapping from problem statement:
    // ABOVE: none asserted (all zero)
    // BETWEEN_2_1: fr0 = 1, fr1 = 0, fr2 = 0
    // BETWEEN_1_0: fr0 = 1, fr1 = 1, fr2 = 0
    // BELOW: fr0 = 1, fr1 = 1, fr2 = 1

    reg fr0_reg, fr1_reg, fr2_reg;
    always @(*) begin
        case (current_state)
            ABOVE: begin
                fr0_reg = 1'b0;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            BETWEEN_2_1: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b0;
                fr2_reg = 1'b0;
            end
            BETWEEN_1_0: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b0;
            end
            BELOW: begin
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
            default: begin
                // default to all open valves
                fr0_reg = 1'b1;
                fr1_reg = 1'b1;
                fr2_reg = 1'b1;
            end
        endcase
    end

    // Supplemental flow valve: asserted (1) when water level rising
    // i.e. current_state > prev_state
    reg dfr_reg;
    always @(*) begin
        dfr_reg = (current_state > prev_state) ? 1'b1 : 1'b0;
    end

    // Assign outputs
    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = dfr_reg;

endmodule