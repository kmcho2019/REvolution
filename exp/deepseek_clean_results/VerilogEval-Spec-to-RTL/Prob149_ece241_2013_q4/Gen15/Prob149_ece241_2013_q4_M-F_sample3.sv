module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;
    reg [1:0] current_state, next_state;

    // State encoding
    localparam ABOVE_ALL  = 2'b00;  // Above s[2]
    localparam MID_HIGH   = 2'b01;  // Between s[2] and s[1]
    localparam MID_LOW    = 2'b10;  // Between s[1] and s[0]
    localparam BELOW_ALL  = 2'b11;  // Below s[0]

    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
            current_state <= BELOW_ALL;
        end else begin
            prev_s <= s;
            current_state <= next_state;

            // State transition logic
            case (s)
                3'b111: next_state = ABOVE_ALL;
                3'b011: next_state = MID_HIGH;
                3'b001: next_state = MID_LOW;
                3'b000: next_state = BELOW_ALL;
                default: next_state = current_state; // handle glitches
            endcase

            // Output logic
            fr0 <= (next_state != ABOVE_ALL);
            fr1 <= (next_state == MID_LOW) | (next_state == BELOW_ALL);
            fr2 <= (next_state == BELOW_ALL);

            // Supplemental flow (rising water)
            dfr <= (next_state > current_state);
        end
    end

endmodule