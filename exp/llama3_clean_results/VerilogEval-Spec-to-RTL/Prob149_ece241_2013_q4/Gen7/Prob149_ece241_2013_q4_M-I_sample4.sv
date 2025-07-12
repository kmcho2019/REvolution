module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states
enum logic [2:0] {
    STATE_ABOVE_S2 = 3'b000,
    STATE_BETWEEN_S2_S1 = 3'b001,
    STATE_BETWEEN_S1_S0 = 3'b010,
    STATE_BELOW_S0 = 3'b011
} state, prev_state;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= STATE_BELOW_S0;
        prev_state <= STATE_BELOW_S0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        case (s)
            3'b111: state <= STATE_ABOVE_S2; // Above s[2]
            3'b110: state <= STATE_BETWEEN_S2_S1; // Between s[2] and s[1]
            3'b100, 3'b101, 3'b110, 3'b111: state <= STATE_BETWEEN_S2_S1; // Between s[2] and s[1]
            3'b011: state <= STATE_BETWEEN_S1_S0; // Between s[1] and s[0]
            3'b001: state <= STATE_BETWEEN_S1_S0; // Between s[1] and s[0]
            3'b000: state <= STATE_BELOW_S0; // Below s[0]
            default: state <= STATE_BELOW_S0;
        endcase
        case (state)
            STATE_ABOVE_S2: begin
                // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            STATE_BETWEEN_S2_S1: begin
                // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state == STATE_BELOW_S0 || prev_state == STATE_BETWEEN_S1_S0)? 1'b1 : 1'b0;
            end
            STATE_BETWEEN_S1_S0: begin
                // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == STATE_BELOW_S0)? 1'b1 : 1'b0;
            end
            STATE_BELOW_S0: begin
                // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule