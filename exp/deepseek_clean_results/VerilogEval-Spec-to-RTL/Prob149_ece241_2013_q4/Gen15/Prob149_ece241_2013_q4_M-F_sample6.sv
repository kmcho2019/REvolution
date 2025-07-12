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
    localparam STATE_LOW  = 2'b00; // Below s[0]
    localparam STATE_MID  = 2'b01; // Between s[1] and s[0]
    localparam STATE_HIGH = 2'b10; // Between s[2] and s[1]
    localparam STATE_FULL = 2'b11; // Above s[2]

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_state = STATE_LOW;  // No sensors
            3'b001: next_state = STATE_MID;  // Only s[0]
            3'b011: next_state = STATE_HIGH; // s[0] and s[1]
            3'b111: next_state = STATE_FULL; // All sensors
            default: next_state = current_state; // Invalid, hold
        endcase
    end

    // Output and state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_LOW;
            prev_state <= STATE_LOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Output logic based on current state
            case(current_state)
                STATE_LOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                STATE_MID: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                STATE_HIGH: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                STATE_FULL: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
            endcase

            // Supplemental flow (rising water)
            dfr <= (current_state < next_state);
        end
    end

endmodule