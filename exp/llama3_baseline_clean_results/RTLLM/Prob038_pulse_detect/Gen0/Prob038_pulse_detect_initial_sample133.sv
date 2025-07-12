module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
localparam IDLE = 2'b00;
localparam RISING_EDGE = 2'b01;
localparam HIGH = 2'b10;
localparam FALLING_EDGE = 2'b11;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to idle and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to rising_edge state when data_in goes high
                    state <= RISING_EDGE;
                    data_out <= 0;
                end else begin
                    // Stay in idle state if data_in remains low
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING_EDGE: begin
                if (data_in) begin
                    // Transition to high state if data_in remains high
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // Go back to idle state if data_in goes low without completing a pulse
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    // Transition to falling_edge state when data_in goes low
                    state <= FALLING_EDGE;
                    data_out <= 0;
                end else begin
                    // Stay in high state if data_in remains high
                    state <= HIGH;
                    data_out <= 0;
                end
            end
            FALLING_EDGE: begin
                // Indicate the end of a pulse and return to idle state
                state <= IDLE;
                data_out <= 1;
            end
            default: begin
                // Handle any unexpected state
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule