module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding
    typedef enum logic [1:0] {
        BELOW_S0,       // No sensors active
        BTWN_S1_S0,     // Only s[0] active
        BTWN_S2_S1,     // s[1:0] active
        ABOVE_S2        // All sensors active
    } state_t;

    state_t current_state, next_state;
    reg [2:0] prev_sensors;
    reg water_rising;

    // Sequential state update and edge detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_sensors <= 3'b000;
            water_rising <= 1'b0;
        end else begin
            prev_sensors <= s;
            current_state <= next_state;
            // Rising if any sensor just became active
            water_rising <= |(s & ~prev_sensors);
        end
    end

    // Next state logic (combinational)
    always_comb begin
        case (s)
            3'b000: next_state = BELOW_S0;
            3'b001: next_state = BTWN_S1_S0;
            3'b011: next_state = BTWN_S2_S1;
            3'b111: next_state = ABOVE_S2;
            default: next_state = current_state; // Hold state for invalid patterns
        endcase
    end

    // Nominal flow outputs (combinational)
    assign fr0 = (current_state != ABOVE_S2);
    assign fr1 = (current_state == BELOW_S0) || (current_state == BTWN_S1_S0);
    assign fr2 = (current_state == BELOW_S0);

    // Supplemental flow output (registered)
    reg dfr_reg;
    always @(posedge clk) begin
        if (reset) begin
            dfr_reg <= 1'b1;
        end else begin
            dfr_reg <= water_rising && (current_state != ABOVE_S2);
        end
    end

    assign dfr = dfr_reg;

endmodule