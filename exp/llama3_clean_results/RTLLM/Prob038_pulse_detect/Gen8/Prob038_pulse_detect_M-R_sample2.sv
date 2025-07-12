module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

enum logic [1:0] {
    IDLE,
    RISING,
    PEAK,
    FALLING
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISING;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                next_state <= PEAK;
                data_out <= 0;
            end
            PEAK: begin
                if (!data_in) begin
                    next_state <= FALLING;
                    data_out <= 0;
                end else begin
                    next_state <= PEAK;
                    data_out <= 0;
                end
            end
            FALLING: begin
                next_state <= IDLE;
                data_out <= 1;
            end
        endcase
    end
end

endmodule