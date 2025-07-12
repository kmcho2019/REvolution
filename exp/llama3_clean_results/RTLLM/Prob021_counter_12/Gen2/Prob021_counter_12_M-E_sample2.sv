module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

enum logic [1:0] {IDLE, COUNTING} state, next_state;
logic [3:0] counter, next_counter;

// FSM state register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 4'b0000;
    end else begin
        state <= next_state;
        counter <= next_counter;
    end
end

// Next state and counter logic
always_comb begin
    next_state = state;
    next_counter = counter;
    case (state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end else if (!rst_n) begin
                next_state = IDLE;
                next_counter = 4'b0000;
            end
        end
        COUNTING: begin
            if (!rst_n) begin
                next_state = IDLE;
                next_counter = 4'b0000;
            end else if (counter == 4'd11) begin
                next_counter = 4'b0000;
            end else begin
                next_counter = counter + 1;
            end
            if (!valid_count) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output assignment
assign out = counter;

endmodule