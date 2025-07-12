module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states - now ordered by physical level
    localparam BELOW   = 2'b00;  // Below s[0]
    localparam LOW     = 2'b01;  // Between s[0]-s[1]
    localparam MID     = 2'b10;  // Between s[1]-s[2]
    localparam ABOVE   = 2'b11;  // Above s[2]

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg water_rising;

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_state = BELOW;   // No sensors
            3'b001: next_state = LOW;     // Only s[0]
            3'b011: next_state = MID;     // s[0] and s[1]
            3'b111: next_state = ABOVE;  // All sensors
            default: next_state = ABOVE;  // Handle any higher sensors
        endcase
    end

    // State register and direction tracking
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
            water_rising <= 1'b0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            // Explicit direction detection
            water_rising <= (next_state > current_state);
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (current_state != ABOVE);
    assign fr1 = reset ? 1'b1 : (current_state == BELOW || current_state == LOW);
    assign fr2 = reset ? 1'b1 : (current_state == BELOW);
    assign dfr = reset ? 1'b1 : (current_state == BELOW) || 
                (water_rising && (current_state != ABOVE));

endmodule