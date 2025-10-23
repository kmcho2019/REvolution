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
    STATE_MIDDLE,
    STATE_HIGH,
    STATE_ABOVE
} state_t;

// Initialize the current state and previous sensor value
state_t current_state;
state_t next_state;
reg [2:0] prev_s;

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
    end else begin
        // Update previous sensor value
        prev_s <= s;

        // Determine the next state
        case (current_state)
            STATE_LOW: begin
                if (s == 3'b001) begin
                    next_state <= STATE_MIDDLE;
                end else if (s == 3'b011) begin
                    next_state <= STATE_MIDDLE;
                end else if (s == 3'b111) begin
                    next_state <= STATE_ABOVE;
                end else begin
                    next_state <= STATE_LOW;
                end
            end
            STATE_MIDDLE: begin
                if (s == 3'b001) begin
                    next_state <= STATE_MIDDLE;
                end else if (s == 3'b011) begin
                    next_state <= STATE_HIGH;
                end else if (s == 3'b111) begin
                    next_state <= STATE_ABOVE;
                end else begin
                    next_state <= STATE_LOW;
                end
            end
            STATE_HIGH: begin
                if (s == 3'b001) begin
                    next_state <= STATE_MIDDLE;
                end else if (s == 3'b011) begin
                    next_state <= STATE_HIGH;
                end else if (s == 3'b111) begin
                    next_state <= STATE_ABOVE;
                end else begin
                    next_state <= STATE_LOW;
                end
            end
            STATE_ABOVE: begin
                if (s == 3'b001) begin
                    next_state <= STATE_MIDDLE;
                end else if (s == 3'b011) begin
                    next_state <= STATE_HIGH;
                end else if (s == 3'b111) begin
                    next_state <= STATE_ABOVE;
                end else begin
                    next_state <= STATE_LOW;
                end
            end
            default: begin
                next_state <= STATE_LOW;
            end
        endcase

        // Update the current state
        current_state <= next_state;

        // Determine the flow rates based on the current state
        case (current_state)
            STATE_LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            STATE_MIDDLE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (current_state > STATE_LOW)? 1'b1 : 1'b0;
            end
            STATE_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (current_state > STATE_LOW)? 1'b1 : 1'b0;
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