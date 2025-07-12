module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [1:0] state, next_state;
logic clock_enable;

// FSM states
enum logic [1:0] {Idle, Counting, Reset} state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= Idle;
        out <= 4'b0000;
    end else begin
        state <= next_state;
        if (clock_enable) begin
            if (out == 4'd11) begin
                out <= 4'b0000;
            end else begin
                out <= out + 1;
            end
        end
    end
end

always_comb begin
    next_state = state;
    clock_enable = 1'b0;
    case (state)
        Idle: begin
            if (valid_count) begin
                next_state = Counting;
            end else if (!rst_n) begin
                next_state = Reset;
            end
        end
        Counting: begin
            clock_enable = valid_count;
            if (!valid_count) begin
                next_state = Idle;
            end else if (!rst_n) begin
                next_state = Reset;
            end
        end
        Reset: begin
            next_state = Idle;
        end
    endcase
end

endmodule