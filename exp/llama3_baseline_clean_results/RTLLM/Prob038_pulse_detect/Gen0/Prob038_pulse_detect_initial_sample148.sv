module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register

// Define the states
localparam IDLE = 2'b00; // Initial state, waiting for rising edge
localparam RISING = 2'b01; // Rising edge detected, waiting for high level
localparam HIGH = 2'b10; // High level detected, waiting for falling edge
localparam FALLING = 2'b11; // Falling edge detected, output pulse detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Initialize state register to initial state
        data_out <= 0; // Set data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Rising edge detected
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Stay in initial state
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin // High level detected
                    state <= HIGH;
                    data_out <= 0;
                end else begin // Not a pulse, go back to initial state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin // Falling edge detected
                    state <= FALLING;
                    data_out <= 1; // Output pulse detected
                end else begin
                    state <= HIGH; // Stay in high level state
                    data_out <= 0;
                end
            end
            FALLING: begin
                state <= IDLE; // Go back to initial state
                data_out <= 0;
            end
            default: begin
                state <= IDLE; // Go back to initial state
                data_out <= 0;
            end
        endcase
    end
end

endmodule