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
                if (data_in == 1) begin
                    state <= 1; // RISING state
                end else begin
                    state <= 0; // Stay in IDLE state
                end
                data_out <= 0;
            end
            1: begin // RISING state
                if (data_in == 1) begin
                    state <= 2; // FALLING state
                end else begin
                    state <= 0; // Return to IDLE state
                end
                data_out <= 0;
            end
            2: begin // FALLING state
                if (data_in == 0) begin
                    state <= 0; // Return to IDLE state
                    data_out <= 1; // Indicate pulse detected
                end else begin
                    state <= 0; // Return to IDLE state
                end
            end
            default: begin
                state <= 0; // IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule