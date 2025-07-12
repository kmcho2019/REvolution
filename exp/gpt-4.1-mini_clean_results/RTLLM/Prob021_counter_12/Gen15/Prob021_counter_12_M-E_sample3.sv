module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// FSM states for counting control
typedef enum logic [0:0] {
    IDLE  = 1'b0,
    COUNT = 1'b1
} state_t;

state_t state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
}

// Next state logic based on valid_count
always @(*) begin
    case(state)
        IDLE:  next_state = valid_count ? COUNT : IDLE;
        COUNT: next_state = valid_count ? COUNT : IDLE;
        default: next_state = IDLE;
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (state == COUNT) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else retain current out value when in IDLE
end

endmodule