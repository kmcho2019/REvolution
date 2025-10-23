module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3
    } state_t;

    // State register
    state_t state, next_state;

    // Sequential state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            // Assert done only when transitioning from BYTE3 to IDLE
            done <= (state == BYTE3);
        end
    end

endmodule