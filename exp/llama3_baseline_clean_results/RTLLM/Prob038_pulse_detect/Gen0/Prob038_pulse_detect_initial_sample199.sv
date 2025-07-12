module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset to IDLE state
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING state
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= IDLE; // Stay in IDLE state
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            RISING: begin
                if (~data_in) begin
                    state <= FALLING; // Transition to FALLING state
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= RISING; // Stay in RISING state
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            FALLING: begin
                data_out <= 1'b1; // Set data_out to 1
                state <= IDLE; // Transition to IDLE state
            end
            default: begin
                state <= IDLE; // Reset to IDLE state
                data_out <= 1'b0; // Reset data_out to 0
            end
        endcase
    end
end

endmodule