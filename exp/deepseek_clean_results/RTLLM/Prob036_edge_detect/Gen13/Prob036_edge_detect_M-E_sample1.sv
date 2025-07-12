module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    typedef enum logic [1:0] {
        IDLE,
        RISING,
        FALLING
    } state_t;

    state_t current_state, next_state;
    reg a_sync;

    // Synchronize input and prevent metastability
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync <= 1'b0;
            current_state <= IDLE;
        end else begin
            a_sync <= a;
            current_state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        next_state = current_state;
        rise = 1'b0;
        down = 1'b0;

        case (current_state)
            IDLE: begin
                if (a_sync && !a) begin
                    next_state = RISING;
                end else if (!a_sync && a) begin
                    next_state = FALLING;
                end
            end
            RISING: begin
                rise = 1'b1;
                next_state = IDLE;
            end
            FALLING: begin
                down = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule