module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count;
logic [1:0] state;

// State machine states
enum logic [1:0] {
    IDLE,
    COUNTING
} state_next, state_curr;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_curr <= IDLE;
        count <= 4'b0000;
    end else begin
        state_curr <= state_next;
        case (state_curr)
            IDLE: begin
                if (valid_count) begin
                    state_next <= COUNTING;
                end else begin
                    state_next <= IDLE;
                end
                count <= 4'b0000;
            end
            COUNTING: begin
                if (count == 4'd11) begin
                    count <= 4'b0000;
                end else begin
                    count <= count + 1;
                end
                if (!valid_count) begin
                    state_next <= IDLE;
                end else begin
                    state_next <= COUNTING;
                end
            end
            default: begin
                state_next <= IDLE;
                count <= 4'b0000;
            end
        endcase
    end
end

// Output logic
assign out = count;

endmodule