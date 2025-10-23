module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Define the FSM states
enum logic [1:0] {IDLE, COUNTING, RESET_STATE} state, next_state;

// FSM state register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end else if (!rst_n) begin
                next_state = RESET_STATE;
            end else begin
                next_state = IDLE;
            end
        end
        COUNTING: begin
            if (!valid_count) begin
                next_state = IDLE;
            end else if (!rst_n) begin
                next_state = RESET_STATE;
            end else begin
                next_state = COUNTING;
            end
        end
        RESET_STATE: begin
            if (rst_n) begin
                next_state = IDLE;
            end else begin
                next_state = RESET_STATE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Counter logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (state == COUNTING) begin
        if (out == 4'd11) begin
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end
end

endmodule