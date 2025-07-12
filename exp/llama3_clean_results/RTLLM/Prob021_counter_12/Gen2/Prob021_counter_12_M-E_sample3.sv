module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

enum logic [1:0] {IDLE, COUNTING, RESET} state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RESET;
        out <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_count) begin
                    next_state <= COUNTING;
                end else begin
                    next_state <= IDLE;
                end
                out <= out;
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
            RESET: begin
                next_state <= IDLE;
                out <= 4'b0000;
            end
        endcase
    end
end

endmodule