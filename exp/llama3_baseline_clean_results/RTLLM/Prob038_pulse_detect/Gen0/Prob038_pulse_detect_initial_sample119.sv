module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // Reset to IDLE state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // Transition to RISING state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
                data_out <= 1'b0;
            end
            2'b01: begin // RISING state
                if (~data_in) begin
                    state <= 2'b10; // Transition to FALLING state
                end else begin
                    state <= 2'b01; // Stay in RISING state
                end
                data_out <= 1'b0;
            end
            2'b10: begin // FALLING state
                if (~data_in) begin
                    state <= 2'b00; // Transition to IDLE state
                    data_out <= 1'b1; // Set data_out to 1
                end else begin
                    state <= 2'b10; // Stay in FALLING state
                    data_out <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // Reset to IDLE state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule