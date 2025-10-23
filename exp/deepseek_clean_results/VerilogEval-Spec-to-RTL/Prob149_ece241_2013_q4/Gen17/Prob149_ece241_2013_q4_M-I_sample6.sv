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
    localparam STATE_BELOW    = 2'b00;  // Below s[0]
    localparam STATE_LOW      = 2'b01;  // Between s[1] and s[0]
    localparam STATE_MID      = 2'b10;  // Between s[2] and s[1]
    localparam STATE_ABOVE    = 2'b11;  // Above s[2]

    reg [1:0] current_state, next_state, prev_state;
    reg rising_edge_detected;

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_state = STATE_BELOW;  // No sensors
            3'b001: next_state = STATE_LOW;    // Only s[0]
            3'b011: next_state = STATE_MID;    // s[0] and s[1]
            3'b111: next_state = STATE_ABOVE;  // All sensors
            default: next_state = current_state; // Invalid patterns maintain state
        endcase
    end

    // State register and dfr logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
            rising_edge_detected <= 1'b1;  // Assert dfr on reset
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Detect rising water level transitions
            rising_edge_detected <= (prev_state < current_state);
        end
    end

    // Output logic
    assign fr0 = (reset) ? 1'b1 : (current_state != STATE_ABOVE);
    assign fr1 = (reset) ? 1'b1 : ((current_state == STATE_LOW) || (current_state == STATE_BELOW));
    assign fr2 = (reset) ? 1'b1 : (current_state == STATE_BELOW);
    assign dfr = (reset) ? 1'b1 : rising_edge_detected;

endmodule