module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
localparam STATE_IDLE = 2'b00;
localparam STATE_RISING = 2'b01;
localparam STATE_FALLING = 2'b10;

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, set the state to STATE_IDLE and data_out to 0
        state <= STATE_IDLE;
        data_out <= 0;
    end else begin
        // Update state and data_out based on the current state and data_in
        state <= next_state;
        case (state)
            STATE_IDLE: begin
                if (data_in) begin
                    // Transition to STATE_RISING when data_in is 1
                    next_state <= STATE_RISING;
                    data_out <= 0;
                end else begin
                    // Stay in STATE_IDLE if data_in is 0
                    next_state <= STATE_IDLE;
                    data_out <= 0;
                end
            end
            STATE_RISING: begin
                if (~data_in) begin
                    // Transition to STATE_FALLING when data_in goes from 1 to 0
                    next_state <= STATE_FALLING;
                    data_out <= 1;
                end else begin
                    // Stay in STATE_RISING if data_in is still 1
                    next_state <= STATE_RISING;
                    data_out <= 0;
                end
            end
            STATE_FALLING: begin
                // Transition back to STATE_IDLE after a pulse
                next_state <= STATE_IDLE;
                data_out <= 0;
            end
            default: begin
                // Default case, should not occur
                next_state <= STATE_IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule