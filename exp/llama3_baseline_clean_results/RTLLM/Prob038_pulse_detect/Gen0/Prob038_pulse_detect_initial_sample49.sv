module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;
localparam S0 = 2'b00; // Initial state or no pulse detected
localparam S1 = 2'b01; // Rising edge detected
localparam S2 = 2'b10; // High state detected
localparam S3 = 2'b11; // Falling edge detected (end of pulse)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= S0;
        data_out <= 0;
    end else begin
        case (state)
            S0: begin
                if (data_in) begin // Rising edge detected
                    state <= S1;
                    data_out <= 0;
                end else begin
                    state <= S0;
                    data_out <= 0;
                end
            end
            S1: begin
                if (data_in) begin // High state detected
                    state <= S2;
                    data_out <= 0;
                end else begin // No pulse, return to initial state
                    state <= S0;
                    data_out <= 0;
                end
            end
            S2: begin
                if (~data_in) begin // Falling edge detected, end of pulse
                    state <= S3;
                    data_out <= 1; // Indicate pulse detection
                end else begin // Still in high state
                    state <= S2;
                    data_out <= 0;
                end
            end
            S3: begin
                state <= S0; // Return to initial state after pulse detection
                data_out <= 0;
            end
            default: begin
                state <= S0;
                data_out <= 0;
            end
        endcase
    end
end

endmodule