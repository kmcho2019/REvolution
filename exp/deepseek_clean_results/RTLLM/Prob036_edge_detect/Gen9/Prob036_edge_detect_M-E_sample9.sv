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
        RISE_DETECTED,
        FALL_DETECTED,
        STABLE
    } state_t;

    state_t current_state, next_state;
    reg a_sync, a_prev;

    // Double synchronizer for metastability protection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            a_sync <= a;
            a_prev <= a_sync;
        end
    end

    // State transition logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (a_prev && !a_sync)
                    next_state = FALL_DETECTED;
                else if (!a_prev && a_sync)
                    next_state = RISE_DETECTED;
                else
                    next_state = STABLE;
            end
            RISE_DETECTED: next_state = STABLE;
            FALL_DETECTED: next_state = STABLE;
            STABLE: begin
                if (a_prev && !a_sync)
                    next_state = FALL_DETECTED;
                else if (!a_prev && a_sync)
                    next_state = RISE_DETECTED;
            end
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Output logic
            rise <= (next_state == RISE_DETECTED);
            down <= (next_state == FALL_DETECTED);
        end
    end

endmodule