module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
parameter IDLE = 2'b00, RISING = 2'b01, HIGH = 2'b10, FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set the state register to the initial state
        data_out <= 0; // Set the data_out output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Rising edge detected
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Stay in the IDLE state
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin // Still high
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin // Falling edge detected
                    state <= FALLING;
                    data_out <= 0;
                end else begin
                    state <= HIGH; // Stay in the HIGH state
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin // Still low
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 1; // Set data_out to 1 to indicate the end of a pulse
                end else begin
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule