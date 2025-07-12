module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    typedef enum logic [1:0] {IDLE, RISING, FALLING} state_t;
    state_t state, next_state;

    // Register input
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (a && !a_prev) next_state = RISING;
                else if (!a && a_prev) next_state = FALLING;
                else next_state = IDLE;
            end
            RISING: next_state = IDLE;
            FALLING: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (state == RISING);
            down <= (state == FALLING);
        end
    end

endmodule