module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: HIGH, 3: FALLING

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset to IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // Transition to RISING
                    data_out <= 0;
                end else begin
                    state <= 0; // Stay in IDLE
                    data_out <= 0;
                end
            end
            1: begin // RISING
                if (data_in) begin
                    state <= 2; // Transition to HIGH
                    data_out <= 0;
                end else begin
                    state <= 0; // Go back to IDLE
                    data_out <= 0;
                end
            end
            2: begin // HIGH
                if (data_in) begin
                    state <= 2; // Stay in HIGH
                    data_out <= 0;
                end else begin
                    state <= 3; // Transition to FALLING
                    data_out <= 1; // Indicate pulse
                end
            end
            3: begin // FALLING
                state <= 0; // Go back to IDLE
                data_out <= 0;
            end
            default: begin
                state <= 0; // Go back to IDLE
                data_out <= 0;
            end
        endcase
    end
end

endmodule