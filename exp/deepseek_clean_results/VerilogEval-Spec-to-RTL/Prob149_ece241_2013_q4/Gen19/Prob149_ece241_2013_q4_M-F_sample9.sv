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
    localparam STATE_BELOW    = 2'b00;  // Below s[0]
    localparam STATE_LOW      = 2'b01;  // Between s[1] and s[0]
    localparam STATE_MID      = 2'b10;  // Between s[2] and s[1]
    localparam STATE_ABOVE    = 2'b11;  // Above s[2]

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg water_rising;

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

    // State register and output generation
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Water rising detection (compare states)
            water_rising = (current_state > prev_state);

            // Output assignments
            fr0 <= (next_state != STATE_ABOVE);
            fr1 <= (next_state == STATE_LOW) || (next_state == STATE_BELOW);
            fr2 <= (next_state == STATE_BELOW);
            dfr <= water_rising;
        end
    end

endmodule