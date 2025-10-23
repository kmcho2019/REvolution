module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    HIGH = 2'b10,
    FALLING = 2'b11
} state, next_state;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Pulse detection logic
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    state <= FALLING;
                    data_out <= 0;
                end else begin
                    state <= HIGH;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= HIGH;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule