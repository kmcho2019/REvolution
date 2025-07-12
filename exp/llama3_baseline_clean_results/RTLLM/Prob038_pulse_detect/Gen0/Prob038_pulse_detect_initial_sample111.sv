module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Declare the states
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    HIGH = 2'b10,
    FALLING = 2'b11
} state, next_state;

// Always block for sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        // Update state and output
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISING;
                    data_out <= 1'b0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            RISING: begin
                if (data_in) begin
                    next_state <= HIGH;
                    data_out <= 1'b0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    next_state <= FALLING;
                    data_out <= 1'b0;
                end else begin
                    next_state <= HIGH;
                    data_out <= 1'b0;
                end
            end
            FALLING: begin
                next_state <= IDLE;
                data_out <= 1'b1;
            end
            default: begin
                next_state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule