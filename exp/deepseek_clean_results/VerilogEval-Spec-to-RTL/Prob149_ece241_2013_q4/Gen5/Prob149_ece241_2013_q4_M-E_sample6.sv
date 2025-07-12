module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding - matches zone numbers
    localparam STATE_ABOVE  = 2'b00;  // Above s[2]
    localparam STATE_MIDHI  = 2'b01;  // Between s[2]-s[1]
    localparam STATE_MIDLO  = 2'b10;  // Between s[1]-s[0]
    localparam STATE_BELOW  = 2'b11;  // Below s[0]

    reg [1:0] current_state, next_state;
    reg level_rising;  // 1 if level was previously lower

    // State transition logic
    always @(*) begin
        casez (s)
            3'b??1: next_state = STATE_ABOVE;  // s[2] high
            3'b?10: next_state = STATE_MIDHI;  // s[1] high, s[2] low
            3'b100: next_state = STATE_MIDLO;  // s[0] high, others low
            3'b000: next_state = STATE_BELOW; // All sensors low
            default: next_state = current_state; // Invalid input
        endcase
    end

    // Edge detection for level changes
    wire state_changed = (next_state != current_state);
    wire level_rose = (next_state > current_state);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            level_rising <= 1'b0;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            if (state_changed) begin
                level_rising <= level_rose;
                current_state <= next_state;
            end

            // Output generation (registered)
            case (current_state)
                STATE_ABOVE: {fr2, fr1, fr0} <= 3'b000;
                STATE_MIDHI: {fr2, fr1, fr0} <= 3'b001;
                STATE_MIDLO: {fr2, fr1, fr0} <= 3'b011;
                STATE_BELOW: {fr2, fr1, fr0} <= 3'b111;
            endcase
            dfr <= level_rising;
        end
    end

endmodule