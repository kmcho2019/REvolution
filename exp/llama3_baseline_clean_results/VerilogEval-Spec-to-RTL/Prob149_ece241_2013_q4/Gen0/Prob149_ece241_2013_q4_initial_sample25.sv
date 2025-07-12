module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states for the FSM
typedef enum logic [1:0] {
    LOW,  // Below s[0]
    MIDDLE_LOW,  // Between s[0] and s[1]
    MIDDLE_HIGH,  // Between s[1] and s[2]
    HIGH  // Above s[2]
} state_t;

// Current state and previous state
state_t current_state;
state_t previous_state;

// FSM logic
always @ (posedge clk) begin
    if (reset) begin
        // Reset to LOW state
        current_state <= LOW;
        previous_state <= LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine previous state
        previous_state <= current_state;

        // Update current state based on sensor inputs
        if (s[2]) begin
            current_state <= HIGH;
        end else if (s[1]) begin
            current_state <= MIDDLE_HIGH;
        end else if (s[0]) begin
            current_state <= MIDDLE_LOW;
        end else begin
            current_state <= LOW;
        end

        // Update flow rate outputs based on current state
        case (current_state)
            HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            MIDDLE_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            MIDDLE_LOW: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase

        // Update dfr (Supplemental flow valve) based on current and previous states
        if ((current_state == MIDDLE_HIGH && previous_state == MIDDLE_LOW) ||
            (current_state == LOW && previous_state == MIDDLE_LOW) ||
            (current_state == MIDDLE_LOW && previous_state == LOW)) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule