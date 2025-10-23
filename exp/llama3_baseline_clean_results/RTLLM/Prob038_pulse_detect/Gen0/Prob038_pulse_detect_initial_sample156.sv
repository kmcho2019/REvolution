module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enum for states
enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state, next_state;

// Output and state registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
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
                next_state <= FALLING;
                data_out <= 0;
            end
            FALLING: begin
                if (~data_in) begin
                    next_state <= IDLE;
                    data_out <= 1;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule