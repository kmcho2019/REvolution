module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    // State encoding
    typedef enum logic [1:0] {
        LOW     = 2'b00,
        RISING  = 2'b01,
        HIGH    = 2'b10,
        FALLING = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= LOW;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            LOW:     next_state = a ? RISING : LOW;
            RISING:  next_state = a ? HIGH : FALLING;
            HIGH:    next_state = a ? HIGH : FALLING;
            FALLING: next_state = a ? RISING : LOW;
            default: next_state = LOW;
        endcase
    end

    // Output logic
    assign rise = (current_state == RISING);
    assign down = (current_state == FALLING);

endmodule