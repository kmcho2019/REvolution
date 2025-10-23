module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    typedef enum logic [1:0] {
        IDLE,
        RISE_DETECTED,
        FALL_DETECTED,
        STABLE
    } state_t;

    state_t current_state, next_state;
    reg a_sync;

    // Synchronize input and state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            a_sync <= 1'b0;
        end else begin
            a_sync <= a;
            current_state <= next_state;
        end
    end

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (a_sync && !a) next_state = RISE_DETECTED;
                else if (!a_sync && a) next_state = FALL_DETECTED;
                else next_state = STABLE;
            end
            RISE_DETECTED: begin
                next_state = STABLE;
            end
            FALL_DETECTED: begin
                next_state = STABLE;
            end
            STABLE: begin
                if (a_sync && !a) next_state = RISE_DETECTED;
                else if (!a_sync && a) next_state = FALL_DETECTED;
                else next_state = STABLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (next_state == RISE_DETECTED);
            down <= (next_state == FALL_DETECTED);
        end
    end

endmodule