module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: FALLING

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset state to IDLE
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to RISING state
                    data_out <= 0; // Output is 0 in IDLE and RISING states
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0; // Output is 0 in IDLE state
                end
            end
            1: begin // RISING state
                if (data_in) begin
                    state <= 1; // Stay in RISING state
                    data_out <= 0; // Output is 0 in RISING state
                end else begin
                    state <= 2; // Transition to FALLING state
                    data_out <= 0; // Output is 0 in FALLING state (for now)
                end
            end
            2: begin // FALLING state
                if (data_in) begin
                    state <= 1; // Transition back to RISING state
                    data_out <= 0; // Output is 0 in RISING state
                end else begin
                    state <= 0; // Transition back to IDLE state
                    data_out <= 1; // Output is 1 at the end of a pulse
                end
            end
            default: begin
                state <= 0; // Reset state to IDLE
                data_out <= 0; // Reset output to 0
            end
        endcase
    end
end

endmodule