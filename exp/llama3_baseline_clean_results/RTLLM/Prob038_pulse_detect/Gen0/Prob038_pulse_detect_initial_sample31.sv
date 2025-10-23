module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: FALLING

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset to IDLE state
        data_out <= 0; // Reset data_out to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to RISING state
                    data_out <= 0; // data_out is 0 in IDLE state
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0; // data_out is 0 in IDLE state
                end
            end
            1: begin // RISING state
                if (~data_in) begin
                    state <= 2; // Transition to FALLING state
                    data_out <= 0; // data_out is 0 in RISING state
                end else begin
                    state <= 1; // Stay in RISING state
                    data_out <= 0; // data_out is 0 in RISING state
                end
            end
            2: begin // FALLING state
                if (~data_in) begin
                    state <= 0; // Transition to IDLE state
                    data_out <= 1; // data_out is 1 at the end of a pulse
                end else begin
                    state <= 2; // Stay in FALLING state
                    data_out <= 0; // data_out is 0 if pulse is not detected
                end
            end
            default: begin
                state <= 0; // Default to IDLE state
                data_out <= 0; // Default data_out to 0
            end
        endcase
    end
end

endmodule