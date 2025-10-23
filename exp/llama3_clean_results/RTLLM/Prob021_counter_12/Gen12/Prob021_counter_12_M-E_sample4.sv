module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

typedef enum logic [1:0] {
    IDLE,
    COUNTING,
    MAX_REACHED
} state_t;

state_t current_state, next_state;
logic [3:0] count;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        count <= 4'b0000;
    end else begin
        current_state <= next_state;
        case (current_state)
            IDLE: begin
                if (valid_count) begin
                    count <= 4'b0001;
                    next_state <= COUNTING;
                end else begin
                    count <= 4'b0000;
                    next_state <= IDLE;
                end
            end
            COUNTING: begin
                if (count == 4'd11) begin
                    next_state <= MAX_REACHED;
                end else if (valid_count) begin
                    count <= count + 1;
                    next_state <= COUNTING;
                end else begin
                    next_state <= COUNTING;
                end
            end
            MAX_REACHED: begin
                count <= 4'b0000;
                next_state <= IDLE;
            end
        endcase
    end
end

assign out = count;

endmodule