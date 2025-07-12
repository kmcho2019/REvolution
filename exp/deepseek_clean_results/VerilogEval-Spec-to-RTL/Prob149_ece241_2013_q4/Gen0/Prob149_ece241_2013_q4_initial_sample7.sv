module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states for water levels
    typedef enum logic [1:0] {
        LEVEL_ABOVE_ALL,    // Above s[2]
        LEVEL_BETWEEN_2_1,  // Between s[2] and s[1]
        LEVEL_BETWEEN_1_0,  // Between s[1] and s[0]
        LEVEL_BELOW_ALL     // Below s[0]
    } state_t;

    state_t current_state, next_state;
    reg [2:0] prev_s;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= LEVEL_BELOW_ALL;
            prev_s <= 3'b000;
        end else begin
            current_state <= next_state;
            prev_s <= s;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            LEVEL_ABOVE_ALL:    next_state = (s == 3'b111) ? LEVEL_ABOVE_ALL    : (s == 3'b011) ? LEVEL_BETWEEN_2_1 : (s == 3'b001) ? LEVEL_BETWEEN_1_0 : LEVEL_BELOW_ALL;
            LEVEL_BETWEEN_2_1:  next_state = (s == 3'b111) ? LEVEL_ABOVE_ALL    : (s == 3'b011) ? LEVEL_BETWEEN_2_1 : (s == 3'b001) ? LEVEL_BETWEEN_1_0 : LEVEL_BELOW_ALL;
            LEVEL_BETWEEN_1_0:  next_state = (s == 3'b111) ? LEVEL_ABOVE_ALL    : (s == 3'b011) ? LEVEL_BETWEEN_2_1 : (s == 3'b001) ? LEVEL_BETWEEN_1_0 : LEVEL_BELOW_ALL;
            LEVEL_BELOW_ALL:    next_state = (s == 3'b111) ? LEVEL_ABOVE_ALL    : (s == 3'b011) ? LEVEL_BETWEEN_2_1 : (s == 3'b001) ? LEVEL_BETWEEN_1_0 : LEVEL_BELOW_ALL;
            default:            next_state = LEVEL_BELOW_ALL;
        endcase
    end

    // Determine if water level was rising (previous level was lower)
    wire level_rising;
    assign level_rising = (prev_s < s);

    // Output logic
    assign fr2 = (current_state == LEVEL_BELOW_ALL);
    assign fr1 = (current_state == LEVEL_BELOW_ALL) || (current_state == LEVEL_BETWEEN_1_0);
    assign fr0 = (current_state == LEVEL_BELOW_ALL) || (current_state == LEVEL_BETWEEN_1_0) || (current_state == LEVEL_BETWEEN_2_1);
    assign dfr = level_rising && (current_state != LEVEL_ABOVE_ALL) && (current_state != LEVEL_BELOW_ALL);

endmodule