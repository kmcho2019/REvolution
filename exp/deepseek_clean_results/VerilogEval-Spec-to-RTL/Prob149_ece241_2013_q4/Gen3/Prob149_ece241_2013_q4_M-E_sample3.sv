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
    localparam ABOVE   = 2'b00;  // Above s[2]
    localparam MID_HIGH = 2'b01; // Between s[2] and s[1]
    localparam MID_LOW = 2'b10;  // Between s[1] and s[0]
    localparam BELOW   = 2'b11;  // Below s[0]

    reg [1:0] current_state, next_state;
    reg was_rising;  // Tracks if last transition was rising

    // State transition logic
    always @(*) begin
        case (current_state)
            ABOVE:    next_state = (s == 3'b111) ? ABOVE    : MID_HIGH;
            MID_HIGH: next_state = (s == 3'b111) ? ABOVE    : 
                                  (s == 3'b011) ? MID_HIGH : MID_LOW;
            MID_LOW:  next_state = (s == 3'b011) ? MID_HIGH :
                                  (s == 3'b001) ? MID_LOW  : BELOW;
            BELOW:    next_state = (s == 3'b001) ? MID_LOW  : BELOW;
            default:  next_state = BELOW;
        endcase
    end

    // State and direction tracking
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            was_rising <= 1'b0;
        end else begin
            if (current_state != next_state) begin
                was_rising <= (next_state < current_state); // Lower state value = higher level
            end
            current_state <= next_state;
        end
    end

    // Output generation
    assign fr0 = (current_state == ABOVE) ? 1'b0 : 1'b1;
    assign fr1 = (current_state == ABOVE || current_state == MID_HIGH) ? 1'b0 : 1'b1;
    assign fr2 = (current_state == BELOW) ? 1'b1 : 1'b0;
    assign dfr = was_rising && (current_state != ABOVE) && (current_state != BELOW);

endmodule