module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Revised state encoding that matches water level hierarchy
    localparam STATE_BELOW    = 2'b00;  // Below s[0] (lowest)
    localparam STATE_LOW      = 2'b01;  // Between s[1] and s[0]
    localparam STATE_MID      = 2'b10;  // Between s[2] and s[1]
    localparam STATE_ABOVE    = 2'b11;  // Above s[2] (highest)

    reg [1:0] current_state, next_state, prev_state;
    reg rising_edge_detected;

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_state = STATE_BELOW;  // No sensors
            3'b001: next_state = STATE_LOW;    // Only s[0]
            3'b011: next_state = STATE_MID;    // s[0] and s[1]
            3'b111: next_state = STATE_ABOVE;  // All sensors
            default: next_state = current_state; // Invalid patterns
        endcase
    end

    // State register and dfr logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
            rising_edge_detected <= 0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Detect rising water level transitions
            rising_edge_detected <= ((prev_state == STATE_BELOW && current_state == STATE_LOW) ||
                                   ((prev_state == STATE_LOW && current_state == STATE_MID) ||
                                   ((prev_state == STATE_MID && current_state == STATE_ABOVE));
        end
    end

    // Output logic - simplified and optimized
    assign fr0 = (current_state != STATE_ABOVE);
    assign fr1 = (current_state == STATE_LOW) || (current_state == STATE_BELOW);
    assign fr2 = (current_state == STATE_BELOW);
    assign dfr = rising_edge_detected;

endmodule