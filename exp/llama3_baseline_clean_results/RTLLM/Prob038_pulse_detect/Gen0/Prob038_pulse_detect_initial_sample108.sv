module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            RISING: begin
                if (~data_in) begin
                    state <= FALLING;
                end else begin
                    state <= RISING;
                end
                data_out <= 0;
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= RISING;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule