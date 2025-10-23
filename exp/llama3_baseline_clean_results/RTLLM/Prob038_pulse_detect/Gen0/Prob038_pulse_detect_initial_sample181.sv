module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Declare the states
enum logic [1:0] {
    IDLE,
    PULSE_STARTED,
    PULSE_ENDED
} state, next_state;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        if (state == PULSE_ENDED) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_STARTED;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_STARTED: begin
            if (~data_in) begin
                next_state = PULSE_ENDED;
            end else begin
                next_state = PULSE_STARTED;
            end
        end
        PULSE_ENDED: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule