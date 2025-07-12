module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // IDLE state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // RISING state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
                data_out <= 1'b0;
            end
            2'b01: begin // RISING state
                if (data_in) begin
                    state <= 2'b10; // PULSE state
                end else begin
                    state <= 2'b00; // Back to IDLE state
                end
                data_out <= 1'b0;
            end
            2'b10: begin // PULSE state
                if (~data_in) begin
                    state <= 2'b11; // FALLING state
                end else begin
                    state <= 2'b10; // Stay in PULSE state
                end
                data_out <= 1'b0;
            end
            2'b11: begin // FALLING state
                state <= 2'b00; // Back to IDLE state
                data_out <= 1'b1; // Assert output signal
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule