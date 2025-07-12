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
            {fr0, fr1, fr2, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Detect water rising (explicit state transitions)
            dfr <= ((prev_state == STATE_BELOW && current_state == STATE_LOW) ||
                   (prev_state == STATE_LOW && current_state == STATE_MID) ||
                   (prev_state == STATE_MID && current_state == STATE_ABOVE));

            // Output assignments
            case (next_state)
                STATE_BELOW: {fr0, fr1, fr2} <= 3'b111;
                STATE_LOW:   {fr0, fr1, fr2} <= 3'b110;
                STATE_MID:   {fr0, fr1, fr2} <= 3'b100;
                STATE_ABOVE: {fr0, fr1, fr2} <= 3'b000;
                default:     {fr0, fr1, fr2} <= 3'b000;
            endcase
        end
    end

endmodule