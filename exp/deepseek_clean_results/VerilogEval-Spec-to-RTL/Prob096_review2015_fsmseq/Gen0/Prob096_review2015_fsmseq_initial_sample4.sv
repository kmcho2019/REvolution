module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        FOUND
    } state_t;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S2 : IDLE;
            S2:   next_state = data ? S2 : S3;
            S3:   next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        start_shifting = (current_state == FOUND);
    end

endmodule