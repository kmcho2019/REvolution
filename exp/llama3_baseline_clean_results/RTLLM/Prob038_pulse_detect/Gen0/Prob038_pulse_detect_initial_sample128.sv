module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the current state
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // State when data_in changes from 0 to 1
parameter FALLING = 2'b10; // State when data_in changes from 1 to 0

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state when data_in changes from 0 to 1
                    state <= RISING;
                    data_out <= 1'b0;
                end else begin
                    // Stay in IDLE state if data_in is still 0
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            RISING: begin
                if (~data_in) begin
                    // Transition to FALLING state when data_in changes from 1 to 0
                    state <= FALLING;
                    data_out <= 1'b0;
                end else begin
                    // Stay in RISING state if data_in is still 1
                    state <= RISING;
                    data_out <= 1'b0;
                end
            end
            FALLING: begin
                // Set data_out to 1 when transitioning from FALLING to IDLE
                data_out <= 1'b1;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule