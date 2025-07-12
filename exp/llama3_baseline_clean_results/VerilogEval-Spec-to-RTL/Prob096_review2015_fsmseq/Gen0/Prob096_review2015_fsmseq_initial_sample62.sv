module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states using parameterized enum
enum logic [2:0] { IDLE, FOUND_1, FOUND_11, FOUND_110, FOUND_1101 } state, next_state;

// Initialize state
initial state = IDLE;

// Sequential logic
always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == FOUND_1101) begin
            start_shifting <= 1;
        end
    end
end

// Combinational logic for next state
always @ (*) begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = FOUND_1;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND_1: begin
            if (data) begin
                next_state = FOUND_11;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND_11: begin
            if (!data) begin
                next_state = FOUND_110;
            end else begin
                next_state = FOUND_1;
            end
        end
        FOUND_110: begin
            if (data) begin
                next_state = FOUND_1101;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND_1101: begin
            next_state = FOUND_1101; // Stay in this state forever
        end
        default: next_state = IDLE;
    endcase
end

endmodule