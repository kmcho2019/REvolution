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
        state <= 0; // IDLE
        data_out <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // RISING
                end else begin
                    state <= 0; // Stay in IDLE
                end
                data_out <= 0;
            end
            1: begin // RISING
                if (~data_in) begin
                    state <= 2; // FALLING
                end else begin
                    state <= 1; // Stay in RISING
                end
                data_out <= 0;
            end
            2: begin // FALLING
                state <= 0; // Go back to IDLE
                data_out <= 1; // Indicate pulse detection
            end
            default: state <= 0; // Default to IDLE
        endcase
    end
end

endmodule