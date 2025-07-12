module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enumerated type for state encoding
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    HIGH = 2'b10,
    FALLING = 2'b11
} state, next_state;

// Clock enable for power optimization
reg clk_enable;

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) next_state = RISING;
            else next_state = IDLE;
            data_out = 0;
            clk_enable = (data_in == 1'b1);
        end
        RISING: begin
            if (data_in) next_state = HIGH;
            else next_state = IDLE;
            data_out = 0;
            clk_enable = 1'b1;
        end
        HIGH: begin
            if (~data_in) next_state = FALLING;
            else next_state = HIGH;
            data_out = 0;
            clk_enable = 1'b1;
        end
        FALLING: begin
            next_state = IDLE;
            data_out = 1'b1;
            clk_enable = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else if (clk_enable) begin
        state <= next_state;
    end
end

endmodule