module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// FSM states
enum logic [1:0] {IDLE, COUNTING} state, next_state;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end else begin
                next_state = IDLE;
            end
        end
        COUNTING: begin
            if (!valid_count) begin
                next_state = IDLE;
            end else begin
                next_state = COUNTING;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for FSM state
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Counter logic
logic [3:0] next_out;
always_comb begin
    if (state == IDLE) begin
        next_out = 4'b0000;
    end else if (state == COUNTING) begin
        if (out == 4'd11) begin
            next_out = 4'b0000;
        end else begin
            next_out = out + 1;
        end
    end else begin
        next_out = 4'b0000;
    end
end

// Sequential logic for counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (state == COUNTING) begin
        out <= next_out;
    end
end

endmodule