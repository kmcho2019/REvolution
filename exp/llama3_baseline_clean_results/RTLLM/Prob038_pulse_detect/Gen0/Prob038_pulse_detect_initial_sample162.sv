module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Declare the states
enum logic [1:0] {
    IDLE = 2'b00,
    HIGH = 2'b01,
    FALLING = 2'b10
} state, next_state;

// Initialize the state register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        if (state == FALLING && data_in == 1'b0) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

// Logic for next state
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state <= HIGH;
            end else begin
                next_state <= IDLE;
            end
        end
        HIGH: begin
            if (data_in == 1'b0) begin
                next_state <= FALLING;
            end else begin
                next_state <= HIGH;
            end
        end
        FALLING: begin
            if (data_in == 1'b1) begin
                next_state <= HIGH;
            end else begin
                next_state <= IDLE;
            end
        end
        default: next_state <= IDLE;
    endcase
end

endmodule