module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: HIGH, 3: FALLING

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // RISING state
                end else begin
                    state <= 0; // Stay in IDLE state
                end
                data_out <= 0;
            end
            1: begin // RISING state
                if (data_in) begin
                    state <= 2; // HIGH state
                end else begin
                    state <= 0; // Back to IDLE state
                end
                data_out <= 0;
            end
            2: begin // HIGH state
                if (~data_in) begin
                    state <= 3; // FALLING state
                end else begin
                    state <= 2; // Stay in HIGH state
                end
                data_out <= 0;
            end
            3: begin // FALLING state
                state <= 0; // Back to IDLE state
                data_out <= 1; // Indicate pulse detection
            end
            default: begin
                state <= 0; // Default to IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule