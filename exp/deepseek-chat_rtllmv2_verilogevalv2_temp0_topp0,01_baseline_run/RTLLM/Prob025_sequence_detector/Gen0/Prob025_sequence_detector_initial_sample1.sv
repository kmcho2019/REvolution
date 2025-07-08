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

    // State registers
    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore style: output depends only on current state)
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sequence_detected <= 1'b0;
        end else begin
            sequence_detected <= (current_state == S4);
        end
    end

endmodule