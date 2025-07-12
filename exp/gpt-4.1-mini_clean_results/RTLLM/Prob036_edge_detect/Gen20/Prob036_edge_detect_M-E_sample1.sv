module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // FSM states encoding
    typedef enum logic [0:0] {
        STATE_0 = 1'b0,
        STATE_1 = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= STATE_0;  // Reset to state representing a = 0
        else
            current_state <= next_state;
    end

    // Next state logic and output logic combined
    always @(*) begin
        // Default outputs and next state
        rise = 1'b0;
        down = 1'b0;
        next_state = current_state;

        case (current_state)
            STATE_0: begin
                if (a == 1'b1) begin
                    next_state = STATE_1;
                    rise = 1'b1;  // Rising edge detected
                end
            end
            STATE_1: begin
                if (a == 1'b0) begin
                    next_state = STATE_0;
                    down = 1'b1;  // Falling edge detected
                end
            end
        endcase
    end

endmodule