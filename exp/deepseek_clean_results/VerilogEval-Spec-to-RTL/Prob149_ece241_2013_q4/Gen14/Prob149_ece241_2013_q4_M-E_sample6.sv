module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // One-hot encoded states
    localparam ABOVE = 3'b100;  // Above s[2]
    localparam HIGH  = 3'b010;  // Between s[2] and s[1]
    localparam MID   = 3'b001;  // Between s[1] and s[0]
    localparam LOW   = 3'b000;  // Below s[0] (default/reset state)

    reg [2:0] current_state, next_state;
    reg was_rising;  // Flag for rising transition

    // State transition logic
    always @(*) begin
        next_state = LOW;
        was_rising = 1'b0;

        case (1'b1)  // Priority encoder style
            (s == 3'b111): next_state = ABOVE;
            (s == 3'b011): next_state = HIGH;
            (s == 3'b001): next_state = MID;
            default:        next_state = LOW;
        endcase

        // Detect rising transition
        if ((next_state == HIGH && current_state != ABOVE) ||
            (next_state == MID  && current_state == LOW)  ||
            (next_state == ABOVE && current_state != ABOVE)) begin
            was_rising = 1'b1;
        end
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= LOW;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            current_state <= next_state;

            // Output logic based on current state
            case (current_state)
                ABOVE: {fr2, fr1, fr0} = 3'b000;
                HIGH:  {fr2, fr1, fr0} = 3'b001;
                MID:   {fr2, fr1, fr0} = 3'b011;
                LOW:   {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b111;
            endcase

            // Supplemental flow only during rising transitions
            dfr <= was_rising;
        end
    end

endmodule