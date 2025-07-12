module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    RISING,
    HIGH,
    FALLING
} state, next_state;

// FSM logic
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
                end else begin
                    next_state <= IDLE;
                end
                data_out <= 0;
            end
            RISING: begin
                if (data_in) begin
                    next_state <= HIGH;
                end else begin
                    next_state <= IDLE;
                end
                data_out <= 0;
            end
            HIGH: begin
                if (~data_in) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= HIGH;
                end
                data_out <= 0;
            end
            FALLING: begin
                next_state <= IDLE;
                data_out <= 1;
            end
        endcase
    end
end

endmodule