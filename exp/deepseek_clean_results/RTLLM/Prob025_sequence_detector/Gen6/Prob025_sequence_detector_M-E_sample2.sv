module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // Define states
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [2:0] history_reg;  // Stores last 3 bits

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            history_reg <= 3'b000;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // Shift in new bit
            history_reg <= {history_reg[1:0], data_in};
            
            // Output is high only in S4 state when we have complete sequence
            sequence_detected <= (next_state == S4);
        end
    end

    // State transition logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: if (data_in) next_state = S1;
            S1:   if (history_reg[1:0] == 2'b00) next_state = S2;
            S2:   if (history_reg[1:0] == 2'b01) next_state = S3;
            S3:   if (data_in) next_state = S4;
            S4:   next_state = IDLE;  // Return to idle after detection
            default: next_state = IDLE;
        endcase
    end

endmodule