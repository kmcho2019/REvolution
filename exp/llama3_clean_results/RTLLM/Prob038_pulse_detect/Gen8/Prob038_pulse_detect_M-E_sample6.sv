module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register for FSM
parameter IDLE = 2'b00, RISING = 2'b01, HIGH = 2'b10, FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE; // Initialize state to IDLE
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING state on rising edge
                end else begin
                    state <= IDLE; // Stay in IDLE state if no rising edge
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH; // Transition to HIGH state if data_in remains high
                end else begin
                    state <= IDLE; // Return to IDLE state if data_in goes low immediately
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (!data_in) begin
                    state <= FALLING; // Transition to FALLING state on falling edge
                end else begin
                    state <= HIGH; // Stay in HIGH state if data_in remains high
                    data_out <= 0;
                end
            end
            FALLING: begin
                data_out <= 1; // Set data_out to 1, indicating pulse detection
                state <= IDLE; // Return to IDLE state after pulse detection
            end
            default: begin
                state <= IDLE; // Default to IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule