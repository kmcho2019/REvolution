module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
typedef enum logic [1:0] {
    STATE_LOW,
    STATE_MIDDLE_LOW,
    STATE_MIDDLE_HIGH,
    STATE_ABOVE
} state_t;

// Initialize the current state and previous sensor value
reg [2:0] prev_s;
state_t current_state;
reg level_increased;

// Determine the next state based on the current state and sensor value
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        current_state <= STATE_LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
        level_increased <= 1'b0;
    end else begin
        // Update previous sensor value
        prev_s <= s;

        // Determine the next state
        case (s)
            3'b000: begin
                current_state <= STATE_LOW;
                level_increased <= 1'b0;
            end
            3'b001: begin
                if (prev_s == 3'b000) begin
                    current_state <= STATE_MIDDLE_LOW;
                    level_increased <= 1'b1;
                end else begin
                    current_state <= STATE_MIDDLE_LOW;
                    level_increased <= 1'b0;
                end
            end
            3'b011: begin
                if (prev_s == 3'b001) begin
                    current_state <= STATE_MIDDLE_HIGH;
                    level_increased <= 1'b1;
                end else begin
                    current_state <= STATE_MIDDLE_HIGH;
                    level_increased <= 1'b0;
                end
            end
            3'b111: begin
                current_state <= STATE_ABOVE;
                level_increased <= 1'b0;
            end
            default: begin
                current_state <= STATE_LOW;
                level_increased <= 1'b0;
            end
        endcase

        // Determine the flow rates based on the current state
        case (current_state)
            STATE_LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            STATE_MIDDLE_LOW: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased;
            end
            STATE_MIDDLE_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increased;
            end
            STATE_ABOVE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
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