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
    localparam STATE_BELOW = 2'b00;  // No sensors
    localparam STATE_LOW   = 2'b01;  // Only s[0]
    localparam STATE_MID   = 2'b10;  // s[0] and s[1]
    localparam STATE_HIGH  = 2'b11;  // All sensors

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_state = STATE_BELOW;
            3'b001: next_state = STATE_LOW;
            3'b011: next_state = STATE_MID;
            3'b111: next_state = STATE_HIGH;
            default: next_state = current_state; // Handle invalid patterns
        endcase
    end

    // State registers and history
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Detect rising level (any state increase)
    wire level_rising = (current_state > prev_state);

    // Output logic
    assign fr0 = (reset) ? 1'b1 : (current_state != STATE_HIGH);
    assign fr1 = (reset) ? 1'b1 : (current_state == STATE_BELOW || current_state == STATE_LOW);
    assign fr2 = (reset) ? 1'b1 : (current_state == STATE_BELOW);
    assign dfr = (reset) ? 1'b1 : level_rising;

endmodule