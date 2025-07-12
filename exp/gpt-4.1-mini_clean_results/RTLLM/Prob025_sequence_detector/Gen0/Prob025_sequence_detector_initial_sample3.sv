module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Active high reset behavior specified:
    // But port named reset_n implies active low reset,
    // the instructions say "When reset is high, the FSM returns to IDLE",
    // so we will treat reset as active high: reset = ~reset_n
    wire reset = ~reset_n;

    // FSM states encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay in S1 if data_in=1
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = S2; // overlapping sequences
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, continue checking for overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore machine - output depends only on current state)
    always @(*) begin
        sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;
    end

endmodule