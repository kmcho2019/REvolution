module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        RISING,
        FALLING
    } state_t;

    state_t current_state, next_state;
    reg a_sync;

    // Synchronize input and avoid metastability
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
    always @(*) begin
        next_state = current_state;
        rise = 1'b0;
        down = 1'b0;

        case (current_state)
            IDLE: begin
                if (a_sync && !a) begin
                    next_state = FALLING;
                    down = 1'b1;
                end
                else if (!a_sync && a) begin
                    next_state = RISING;
                    rise = 1'b1;
                end
            end
            RISING: begin
                next_state = IDLE;
                if (a_sync && !a) begin
                    next_state = FALLING;
                    down = 1'b1;
                end
            end
            FALLING: begin
                next_state = IDLE;
                if (!a_sync && a) begin
                    next_state = RISING;
                    rise = 1'b1;
                end
            end
        endcase
    end

endmodule