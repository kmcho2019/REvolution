module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding
    localparam STATE_BELOW    = 2'b00;  // Below s[0] (no sensors)
    localparam STATE_LOW      = 2'b01;  // Between s[1] and s[0] (only s[0])
    localparam STATE_MID      = 2'b10;  // Between s[2] and s[1] (s[0] and s[1])
    localparam STATE_ABOVE    = 2'b11;  // Above s[2] (all sensors)

    reg [1:0] current_state, next_state, prev_state;

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

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Update outputs based on current state
            fr0 <= (current_state != STATE_ABOVE);
            fr1 <= (current_state == STATE_LOW) || (current_state == STATE_BELOW);
            fr2 <= (current_state == STATE_BELOW);
            
            // Detect rising water level (only between valid states)
            dfr <= (prev_state < current_state) && 
                  (prev_state != current_state) && 
                  (prev_state != 2'bxx) && 
                  (current_state != 2'bxx);
        end
    end

endmodule