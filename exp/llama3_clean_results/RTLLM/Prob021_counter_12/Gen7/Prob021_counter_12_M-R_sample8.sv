module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

enum logic [1:0] {IDLE, COUNTING} state, next_state;

always_ff @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        out <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_count) begin
                    out <= 4'b0000;
                    next_state <= COUNTING;
                end else begin
                    out <= 4'b0000;
                    next_state <= IDLE;
                end
            end
            COUNTING: begin
                if (out == 4'd11) begin
                    out <= 4'b0000;
                end else begin
                    out <= out + 1;
                end
                if (!valid_count) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= COUNTING;
                end
            end
            default: begin
                out <= 4'b0000;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule