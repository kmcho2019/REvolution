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

    // Double synchronizer for metastability protection
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
                    next_state = RISING;
                    rise = 1'b1;
                end
                else if (!a_sync && a) begin
                    next_state = FALLING;
                    down = 1'b1;
                end
            end
            RISING: begin
                if (!a_sync) begin
                    next_state = IDLE;
                end
            end
            FALLING: begin
                if (a_sync) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule