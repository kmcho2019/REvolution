module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

enum logic [1:0] {IDLE, COUNTING} state, next_state;
logic [3:0] counter;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_count) begin
                    next_state <= COUNTING;
                end else begin
                    next_state <= IDLE;
                end
                counter <= 4'b0000;
            end
            COUNTING: begin
                if (!valid_count) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= COUNTING;
                end
                if (counter == 4'd11) begin
                    counter <= 4'b0000;
                end else begin
                    counter <= counter + 1;
                end
            end
            default: begin
                next_state <= IDLE;
                counter <= 4'b0000;
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: out = 4'b0000;
        COUNTING: out = counter;
        default: out = 4'b0000;
    endcase
end

endmodule