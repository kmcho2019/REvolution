module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: FALLING
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // RISING state
                    data_out <= 0;
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0;
                end
            end
            1: begin // RISING state
                if (data_in) begin
                    state <= 2; // FALLING state
                    data_out <= 0;
                end else begin
                    state <= 0; // Go back to IDLE state
                    data_out <= 0;
                end
            end
            2: begin // FALLING state
                state <= 0; // Go back to IDLE state
                data_out <= 1; // Pulse detected
            end
            default: begin
                state <= 0; // Default to IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule