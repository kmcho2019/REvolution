module TopModule(
    input  wire        clk,
    input  wire        reset_n,
    input  wire        ring,
    input  wire        vibrate_mode,
    output reg         ringer,
    output reg         motor
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ACTIVE = 2'b01
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (ring)
                    next_state = ACTIVE;
                else
                    next_state = IDLE;
            end
            ACTIVE: begin
                if (!ring)
                    next_state = IDLE;
                else
                    next_state = ACTIVE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic registered to state and vibrate_mode
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ringer <= 1'b0;
            motor  <= 1'b0;
        end else begin
            if (state == ACTIVE) begin
                if (vibrate_mode) begin
                    ringer <= 1'b0;
                    motor  <= 1'b1;
                end else begin
                    ringer <= 1'b1;
                    motor  <= 1'b0;
                end
            end else begin
                ringer <= 1'b0;
                motor  <= 1'b0;
            end
        end
    end

endmodule