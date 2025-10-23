module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
enum logic [2:0] {
    IDLE = 3'b000,
    FOUND_1 = 3'b001,
    FOUND_11 = 3'b010,
    FOUND_110 = 3'b011,
    FOUND_SEQUENCE = 3'b100
} current_state, next_state;

// Initialize the FSM
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == FOUND_SEQUENCE) begin
            start_shifting <= 1;
        end else if (current_state == IDLE && next_state == IDLE) begin
            start_shifting <= 0;
        end
    end
end

// FSM logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state <= FOUND_1;
            end else begin
                next_state <= IDLE;
            end
        end
        FOUND_1: begin
            if (data == 1'b1) begin
                next_state <= FOUND_11;
            end else if (data == 1'b0) begin
                next_state <= IDLE;
            end
        end
        FOUND_11: begin
            if (data == 1'b0) begin
                next_state <= FOUND_110;
            end else if (data == 1'b1) begin
                next_state <= FOUND_11;
            end
        end
        FOUND_110: begin
            if (data == 1'b1) begin
                next_state <= FOUND_1;
            end else if (data == 1'b0) begin
                next_state <= FOUND_SEQUENCE;
            end
        end
        FOUND_SEQUENCE: begin
            next_state <= FOUND_SEQUENCE;
        end
    endcase
end

endmodule